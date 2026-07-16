# 'Transformation (Normalization)
#'
#'\strong Normalization
#'
#'Performs normalization of Land Surface Parameters (LSPs), based Huang et al. (2021)
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' ni <- slope::normalization(dem, 7)
#' plot(ni)
#'@export
normalization <- function(x, sp_range){
  max <- x|>
    terra::focal(sp_range, 'max')
  min <- x|>
    terra::focal(sp_range, 'min')
  ni <- (x - min)/(max - min)
  return(ni)
}
