#'Roughness Index
#'
#'Calculates Roughness Index, based in Trevisani and Cavalli (2016).
#'
#'@param x Input DEM raster file.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
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
roughness_index <- function(x, sp_range){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else{
  smoothed_dem <- terra::focal(x, w = sp_range, 'mean')
  residual_dem <- x - smoothed_dem
  r <- terra::focal(residual_dem, sp_range, 'sd')|>
    terra::clamp(lower = 0.001)
  r_max <- log(terra::focal(r, w = sp_range, 'max'))|>
    terra::clamp(lower = 0.001)
  r_min <- log(terra::focal(r, w = sp_range, 'min'))|>
    terra::clamp(lower = 0.001)
  logr <- log(r)
  r1 <- logr - r_min
  r1 <- terra::clamp(r1, lower = 0.001)
  r2 <- r_max - r_min
  r2 <- terra::clamp(r2, lower = 0.001)
  w <- 1 - (r1 / r2)
  w <- terra::clamp(w, lower = 0.001, upper = 1.0)
  return(w)
  }
}
