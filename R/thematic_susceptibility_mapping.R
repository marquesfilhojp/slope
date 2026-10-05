#'Thematic Susceptibility Mapping
#'
#'Performing different forms of thematic susceptibility mapping through machine learning, based on Filho et al. (2024).
#'
#'@param x Input stack raster
#'@param y Input samples (vector files)
#'@param target_col Target field of occurrence
#'@param p Regarding the number of samples representing the non-occurrence of events, it is suggested, in order to balance the sample set, to use a sample size equal to the number of event occurrences.
#'@param drop_cols This allows you to remove information that will not be used in susceptibility modeling.
#'@param k_folds Number of folds or number of resampling iterations, using cross-validation method.
#'@param method Random Forest "rf" or Support Vector Machine "svm"
#'@param mtry Randomly selected predictors
#'@param ntree Decision tree number
#'@param cost Constraint violation cost, where 'C' is the regularization parameter.
#'@param preProcess Estimates the required parameters for each operation (e.g., 'nzv' for near-zero variance filtering, or c('center', 'scale') for normalization). For details on available pre-processing methods, see the caret package R documentation.
#'@param n_class The positive class value for the confusion matrix (e.g., 0 for non-occurrence and 1 for occurrence).
#'@param predict Predicted thematic susceptibility status, where 0 indicates non-occurrence and 1 indicates occurrence.
#'@param path_metrics Path to save the machine learning model metrics in tabular format.
#'@param path_var_imp Path to save the machine learning model variable importance in tabular format.
#'@param path_prediction Path to save the susceptibility prediction in raster/matrix format.
#'
#'@examples
#'library(terra)
#'library(slope)
#'rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
#'samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
#'tsm <- slope::thematic_susceptibility_mapping(rasters, samples, "classes", 0.7, -c(1,3,15), 5, "rf", 10, 1000, NULL,
#'                                              "nzv", 1, 2, "ex/metrics.txt", "ex/var_imp.txt", "ex/predict.tif")
#' plot(tsm)
#'@export
thematic_susceptibility_mapping <- function(x, y, target_col, p, drop_cols, k_folds, method, mtry, ntree, cost, preProcess, n_class, predict, path_metrics, path_var_imp, path_prediction){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(y) || is.null(y) || (!inherits(y, "sf") && !inherits(y, "SpatVector"))){
    stop("Argument 'y' must be provided and inherit from class 'sf' or 'SpatVector'.", call. = FALSE)
  } else if(missing(target_col) || is.null(target_col)){
    stop("Argument 'target_col' must be provided.", call. = FALSE)
  } else if(missing(p) || is.null(p) || !is.numeric(p)){
    stop("Argument 'p' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(k_folds) || is.null(k_folds) || !is.numeric(k_folds)){
    stop("Argument 'k_folds' must be provided and be a numeric integer.", call. = FALSE)
  } else if(missing(method) || is.null(method) || !is.character(method)){
    stop("Argument 'method' must be provided and be a character string ('rf' or 'svm').", call. = FALSE)
  } else{
    dataset <- x|>
      terra::extract(y, bind = TRUE)|>
      sf::st_as_sf()|>
      sf::st_drop_geometry()|>
      as.data.frame()

    dataset[[target_col]] <- as.factor(dataset[[target_col]])

    data_partition <- caret::createDataPartition(dataset[[target_col]], p = p, list = FALSE)

    train <- dataset[data_partition, drop_cols]
    train <- na.omit(train)

    test <- dataset[-data_partition, drop_cols]
    test <- na.omit(test)

    cv_folds <- caret::createFolds(train[[target_col]], k = k_folds, returnTrain = TRUE, list = TRUE)
    trControl <- caret::trainControl(method = 'cv', number = k_folds, p = p, search = 'grid', index = cv_folds, allowParallel = TRUE)

    form <- as.formula(paste(target_col, "~ ."))

    if(method == 'rf'){
      tuneGrid <- expand.grid(mtry = seq(1, mtry, by = 1))
      model <- caret::train(form, data = train, method = 'rf', ntree = ntree, metric = 'Accuracy',
                            trControl = trControl, tuneGrid = tuneGrid, preProcess = preProcess)
    } else if(method == 'svm'){
      tuneGrid <- expand.grid(C = seq(0.1, cost, by = 0.2))
      model <- caret::train(form, data = train, method = 'svmLinear',
                            trControl = trControl, tuneGrid = tuneGrid, preProcess = preProcess, prob.model = TRUE)
    } else{
      stop("Invalid 'method'. Choose between 'rf' or 'svm'.", call. = FALSE)
    }

    pred <- caret::predict.train(model, test)
    cm <- caret::confusionMatrix(pred, test[[target_col]], positive = as.character(n_class))
    accuracy <- cm$overall['Accuracy']
    precision <- cm$byClass['Pos Pred Value']
    recall <- cm$byClass['Sensitivity']
    f1_score <- 2 * (precision * recall)/(precision + recall)

    metrics <- data.frame(accuracy = round(as.numeric(accuracy), 3),
                          precision = round(as.numeric(precision), 3),
                          recall = round(as.numeric(recall), 3),
                          f1_score = round(as.numeric(f1_score), 3))
    print(metrics)
    write.table(metrics, path_metrics, append = FALSE)

    imp <- caret::varImp(model, scale = TRUE)$importance |>
      as.data.frame()
    print(imp)
    write.table(imp, path_var_imp, append = FALSE)

    model_class <- terra::predict(x, model, progress = "text", type = "prob", index = 1:2, na.rm = TRUE)
    plot(model_class[[predict]])
    terra::writeRaster(model_class[[predict]], path_prediction, overwrite = TRUE)

    return(model_class[[predict]])
  }
}
