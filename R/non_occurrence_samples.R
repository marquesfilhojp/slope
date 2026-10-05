#'Non Occurrence Samples
#'
#'Determines non-occurrence samples of susceptibility based on the Buffer Controlling Samples (BCS) method described by Gu et al. (2024).
#'
#'@param x Input stack raster
#'@param y Input samples (vector files)
#'@param distance Area or zone of influence of the event occurrence samples.
#'@param n_samples Regarding the number of samples representing the non-occurrence of events, it is suggested, in order to balance the sample set, to use a sample size equal to the number of event occurrences.
#'@param drop_cols_non This allows you to remove information that will not be used; it is suggested to leave only the column referring to the non-occurrence of events, e.g [0].
#'@param drop_cols It allows for the removal of unused information; it is suggested to retain only the column regarding event occurrences, e.g [1].
#'@param col Target field of occurrence.
#'
#'@examples
#'\dontrun{
#'library(pacman)
#'p_load(terra, sf, slope)
#'rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
#'samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
#'non_occurrence <- slope::non_occurrence_samples(rasters, samples, 500, 1218, -c(1:14), -c(1), 'classes')
#'plot(non_occurrence)
#'}
#'@export
non_occurence_samples <- function(x, y, distance, n_samples, drop_cols_non, drop_cols, col){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(y) || is.null(y) || !inherits(y, "SpatVector")){
    stop("Argument 'y' must be provided and inherit from class 'SpatVector'.", call. = FALSE)
  } else if(missing(distance) || is.null(distance) || !is.numeric(distance)){
    stop("Argument 'distance' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(n_samples) || is.null(n_samples) || !is.numeric(n_samples)){
    stop("Argument 'n_samples' must be provided and be a numeric integer.", call. = FALSE)
  } else if(missing(drops_cols_non) || is.null(drops_cols_non)){
    stop("Argument 'drop_cols_non' must be provided.", call. = FALSE)
  } else if(missing(drops_cols) || is.null(drops_col)) {
    stop("Argument 'drop_cols' must be provided.", call. = FALSE)
  } else if(missing(col) || is.null(col) || !is.character(col)) {
    stop("Argument 'col' must be provided and be a character string.", call. = FALSE)
  } else{
  dist_samples <- y|>
    sf::st_as_sf()|>
    sf::st_buffer(distance)|>
    terra::vect()
  mask <- x|>
    terra::mask(dist_samples, inverse = T)
  non_samples <- terra::spatSample(mask, size = n_samples, method = "random",
                                   na.rm = T, as.points = T, xy = T, each = F)|>
    sf::st_as_sf()
  non_samples[[col]] <- 0
  non_samples <- non_samples[, drop_cols_non]
  samples <- sf::st_as_sf(y)
  samples <- samples[, drop_cols]
  all_samples <- rbind(non_samples, samples)
  return(all_samples)
  }
}
