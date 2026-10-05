#'Roughness Index
#'
#'Calculates Roughness Index, based in Trevisani and Cavalli (2016).
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'ri <- slope::roughness_index(dem, 5)
#'plot(ri)
#'}
#'@export
roughness_index <- function(x, w){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else{
  smoothed_dem <- terra::focal(x, w = w, 'mean')
  residual_dem <- x - smoothed_dem
  r <- terra::focal(residual_dem, w, 'sd')|>
    terra::clamp(lower = 0.001)
  r_max <- log(terra::focal(r, w = w, 'max'))|>
    terra::clamp(lower = 0.001)
  r_min <- log(terra::focal(r, w = w, 'min'))|>
    terra::clamp(lower = 0.001)
  logr <- log(r)
  r1 <- logr - r_min
  r1 <- terra::clamp(r1, lower = 0.001)
  r2 <- r_max - r_min
  r2 <- terra::clamp(r2, lower = 0.001)
  w_r <- 1 - (r1 / r2)
  w_r <- terra::clamp(w, lower = 0.001, upper = 1.0)
  names(w_r) <- "roughness_index"
  return(w_r)
  }
}
