#'Fill
#'
#'Performs the filling of spurious depressions in DEMs based on the wbt_fill_depressions() function (Lindsay, 2016).
#'
#'@param x Input DEM raster
#'@param y Output filled raster file
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'dem_fill <- slope::fill(dem, system.file("ex/fill.tif'))
#'plot(dem_fill)
#'}
#'@export
fill <- function(x, y){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(y) || is.null(y) || !is.character(y)){
    stop("Argument 'y' must be provided and be a character string.", call. = FALSE)
  } else{
  whitebox::install_whitebox()
  whitebox::wbt_fill_depressions(dem = terra::sources(x),
                       output = output,
                       fix_flats = T,
                       flat_increment = NULL,
                       max_depth = NULL)
  return(terra::rast(y))
  }
}
