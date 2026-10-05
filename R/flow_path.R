#'Flow Path
#'
#'Performs the flow path in DEMs based on the wbt_downslope_distance_to_stream() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input DEM raster
#'@param y Input streams raster
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'streams <- terra::rast(system.file("ex/streams.tif", package = "terra"))
#'fp <- slope::flow_path(dem, s)
#'plot(fp)
#'}
#'@export
flow_path <- function(x, y){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'dem' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(y) || is.null(y) || !inherits(y, "SpatRaster")){
    stop("Argument 'y' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else{
  whitebox::install_whitebox()
  flow_path  <- tempfile(pattern = "flow_path", fileext = ".tif")
  wbt_downslope_distance_to_stream(
    dem = terra::sources(x),
    streams = terra::sources(y),
    output = flow_path)
  return(terra::rast(flow_path))
  }
}
