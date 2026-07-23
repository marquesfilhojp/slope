#' Surface Relief Ratio
#'
#'\strong{Surface Relief Ratio}
#'
#'Calculates Surface Relief Ratio, based Berry (2002).
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' srr <- slope::surface_relief_ratio(dem, 7)
#' plot(srr)
#' }
#'@export
surface_relief_ratio <- function(x, sp_range){
  max <- x|>
    terra::focal(sp_range, 'max')
  min <- x|>
    terra::focal(sp_range, 'min')
  mean <- x|>
    terra::focal(sp_range, 'mean')
  srr <- (mean - min)/(max - min)
  return(srr)
}
