#' Flow Path
#'
#'\strong{Flow Path}
#'
#'Performs the flow path in DEMs based on the wbt_downslope_distance_to_stream() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input DEM raster file.
#'@param y Input Streams raster file.
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' s <- terra::rast(system.file("ex/streams.tif", package = "terra"))
#' fp <- slope::flow_path(dem, s)
#' plot(fp)
#' }
#'@export
flow_path <- function(x, y){
  whitebox::install_whitebox()
  flow_path  <- tempfile(pattern = "flow_path", fileext = ".tif")
  wbt_downslope_distance_to_stream(
    dem = terra::sources(x),
    streams = terra::sources(y),
    output = flow_path)
  return(terra::rast(flow_path))
}
