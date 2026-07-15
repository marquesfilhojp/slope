# 'Dissection Index
#'
#'\strong Dissection Index
#'
#'Detects spatial patterns of dissection, based in Evans (1972).
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.shp", package = "terra"))
#' di <- slope::dissection_index(dem, 7)
#' plot(di)
#'@export
dissection_index <- function(x, sp_range){
  max <- x|>
    terra::focal(sp_range, 'max')
  min <- x|>
    terra::focal(sp_range, 'min')
  di <- (x - min)/(max - min)
  return(di)
}
