# Thematic Susceptibility Mapping

Performing different forms of thematic susceptibility mapping through
machine learning, based on Filho et al. (2024).

## Usage

``` r
thematic_susceptibility_mapping(
  x,
  y,
  target_col,
  p,
  drop_cols,
  k_folds,
  method,
  mtry,
  ntree,
  cost,
  preProcess,
  n_class,
  predict,
  path_metrics,
  path_var_imp,
  path_prediction
)
```

## Arguments

- x:

  Input stack raster

- y:

  Input samples (vector files)

- target_col:

  Target field of occurrence

- p:

  Regarding the number of samples representing the non-occurrence of
  events, it is suggested, in order to balance the sample set, to use a
  sample size equal to the number of event occurrences.

- drop_cols:

  This allows you to remove information that will not be used in
  susceptibility modeling.

- k_folds:

  Number of folds or number of resampling iterations, using
  cross-validation method.

- method:

  Random Forest "rf" or Support Vector Machine "svm"

- mtry:

  Randomly selected predictors

- ntree:

  Decision tree number

- cost:

  Constraint violation cost, where 'C' is the regularization parameter.

- preProcess:

  Estimates the required parameters for each operation (e.g., 'nzv' for
  near-zero variance filtering, or c('center', 'scale') for
  normalization). For details on available pre-processing methods, see
  the caret package R documentation.

- n_class:

  The positive class value for the confusion matrix (e.g., 0 for
  non-occurrence and 1 for occurrence).

- predict:

  Predicted thematic susceptibility status, where 0 indicates
  non-occurrence and 1 indicates occurrence.

- path_metrics:

  Path to save the machine learning model metrics in tabular format.

- path_var_imp:

  Path to save the machine learning model variable importance in tabular
  format.

- path_prediction:

  Path to save the susceptibility prediction in raster/matrix format.

## Examples

``` r
library(terra)
library(slope)
rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
#> Error: [rast] filename is empty. Provide a valid filename
samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
#> Error: [vect] file does not exist: 
tsm <- slope::thematic_susceptibility_mapping(rasters, samples, "classes", 0.7, -c(1,3,15), 5, "rf", 10, 1000, NULL,
                                             "nzv", 1, 2, "ex/metrics.txt", "ex/var_imp.txt", "ex/predict.tif")
#> Error: object 'rasters' not found
plot(tsm)
#> Error in h(simpleError(msg, call)): error in evaluating the argument 'x' in selecting a method for function 'plot': object 'tsm' not found
```
