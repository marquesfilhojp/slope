#'Thematic Susceptibility Mapping
#'
#'Performing different forms of thematic susceptibility mapping through machine learning, based on Filho et al. (2024).
#'
#'@param x Input stack raster files.
#'@param y Input samples (vector files) in terra or sf package R.
#'@param target_col Numeric. Target field of occurrence.
#'@param p Numeric. Regarding the number of samples representing the non-occurrence of events, it is suggested, in order to balance the sample set, to use a sample size equal to the number of event occurrences.
#'@param drop_cols This allows you to remove information that will not be used in susceptibility modeling.
#'@param k_folds Numeric. Number of folds or number of resampling iterations, using cross-validation method.
#'@param method Random Forest "rf" or Support Vector Machine "svm"
#'@param mtry Numeric. Randomly selected predictors
#'@param ntree Numeric. Decision tree number
#'@param cost Numeric. Constraint violation cost, where 'C' is the regularization parameter.
#'@param preProcess Estimates the required parameters for each operation (e.g., 'nzv' for near-zero variance filtering, or c('center', 'scale') for normalization). For details on available pre-processing methods, see the caret package R documentation.
#'@param n_class Numeric. The positive class value for the confusion matrix (e.g., 0 for non-occurrence and 1 for occurrence).
#'@param predict Numeric. Predicted thematic susceptibility status, where 1 indicates non-occurrence and 2 indicates occurrence.
#'@param path_metrics Character. Path to save the machine learning model metrics in tabular format.
#'@param path_var_imp Character. Path to save the machine learning model variable importance in tabular format.
#'@param path_prediction Character. Path to save the susceptibility prediction in raster/matrix format.
#'
#'@examples
#' library(pacman)
#' p_load(terra, slope)
#' rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
#' samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
#' tsm <- slope::thematic_susceptibility_mapping(rasters, samples, "classes", 0.7, -c(1,3,15), 5, "rf", 10, 1000, NULL,
#'                                              "nzv", 1, 2, "ex/metrics.txt", "ex/var_imp.txt", "ex/predict.tif")
#' plot(tsm)
#'
thematic_susceptibility_mapping <- function(x, y, target_col, p, drop_cols, k_folds, method, mtry, ntree, cost, preProcess, n_class, predict, path_metrics, path_var_imp, path_prediction){
  dataset <- x|>
    terra::extract(y, bind = T)|>
    sf::st_as_sf()|>
    as.data.frame()
  dataset[[target_col]] <- as.factor(dataset[[target_col]])
  data_partition <- createDataPartition(dataset[, target_col], p = p, list = F)
  train <- dataset[data_partition, drop_cols]
  colSums(is.na(train))
  train <- na.omit(train)
  length(train[[target_col]])
  test <- dataset[-data_partition, drop_cols]
  colSums(is.na(test))
  test <- na.omit(test)
  length(test[[target_col]])
  cv_folds <- createFolds(train[[target_col]], k = k_folds, returnTrain = T, list = T)
  trControl <- trainControl(method = 'cv', number = k_folds, p = p, search = 'grid', index = cv_folds,  allowParallel = T)
  form <- as.formula(paste(target_col, "~ ."))
  if(method == 'rf'){
    tuneGrid = expand.grid(mtry = seq(1, mtry, by = 1))
    model <- train(form, data = train, method = 'rf', ntree = ntree, metric = 'Accuracy',
                   trControl = trControl, tuneGrid = tuneGrid, preProcess = preProcess)
  } else if (method == 'svm'){
    tuneGrid <- expand.grid(C = seq(0.1, cost, by = 0.2))
    model <- train(form, data = train, method = 'svmLinear',
                   trControl = trControl, tuneGrid = tuneGrid, preProcess = preProcess, prob.model = T)
  } else{
    print("method must be 'rf' or 'svm'")
  }
  print(method)
  pred <- caret::predict.train(model, test)
  cm <- caret::confusionMatrix(pred, test[[target_col]], positive = n_class)
  accuracy <- cm$overall['Accuracy']
  precision <- cm$byClass['Pos Pred Value']
  recall <- cm$byClass['Sensitivity']
  f1_score <- 2 * (precision * recall)/(precision + recall)
  metrics <- data.frame(accuracy = as.numeric(accuracy)|>
                          round(3),
                        precision = as.numeric(precision)|>
                          round(3),
                        recall = as.numeric(recall)|>
                          round(3),
                        f1_score = as.numeric(f1_score)|>
                          round(3))
  print(metrics)
  write.table(metrics, path_metrics, append = F)
  imp <- caret::varImp(model, scale = T)$importance|>
    as.data.frame()
  print(imp)
  write.table(imp, path_var_imp, append = F)
  model_class <- terra::predict(x, model, progress = "text", type = "prob", index = 1:2, na.rm = T)
  plot(model_class[[predict]])
  writeRaster(model_class[[predict]], path_prediction, overwrite = T)
}
