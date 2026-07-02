# 'Fill
#'
#'\strong Spurious Depressions Filling
#'
#'Performs the filling of spurious depressions in DEMs,
#'\code based on the wbt_fill_depressions() function (Lindsay, 2016)
#'
#'@param x Input DEM raster file.
#'@param y Output filled raster file.
#'
#'@examples
#' library(terra)
#' dem <- terra::rast(system.file("ex/elev.tif", package="terra"))
#' dem_fill <- slope::fill(dem, 'fill.tif')
#' plot(dem_fill)
#'@export
fill <- function(x, y){
  whitebox::install_whitebox()
  whitebox::wbt_fill_depressions(dem = terra::sources(x),
                       output = y,
                       fix_flats = T,
                       flat_increment = NULL,
                       max_depth = NULL)
  return(terra::rast(y))
}
