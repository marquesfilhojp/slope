#'Non Occurrence Samples
#'
#'Determines non-occurrence samples of susceptibility based on the Buffer Controlling Samples (BCS) method described by Gu et al. (2024).
#'
#'@param x Input stack raster files.
#'@param y Input samples (vector files) in terra or sf package R.
#'@param distance Numeric. Area or zone of influence of the event occurrence samples.
#'@param n_samples Numeric. Regarding the number of samples representing the non-occurrence of events, it is suggested, in order to balance the sample set, to use a sample size equal to the number of event occurrences.
#'@param drop_cols_non This allows you to remove information that will not be used; it is suggested to leave only the column referring to the non-occurrence of events, e.g [0].
#'@param drop_cols It allows for the removal of unused information; it is suggested to retain only the column regarding event occurrences, e.g [1].
#'@param col Target field of occurrence.
#'
#'@examples
#' library(pacman)
#' p_load(terra, sf, slope)
#' rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
#' samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
#' nos <- slope::non_occurrence_samples(rasters, samples, 500, 1218, -c(1:14), -c(1), 'classes')
#' plot(nos)
#'
non_occurence_samples <- function(x, y, distance, n_samples, drop_cols_non, drop_cols, col){
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
