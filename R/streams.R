#' Streams
#'
#'\strong{Streams}
#'
#'Performs identification of streams in DEMs based on the wbt_extract_streams() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input Flow Accumulation raster file.
#'@param threshold Numeric. For extraction of streams.
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' fa <- terra::rast(system.file("ex/accum.tif", package = "terra"))
#' s <- slope::streams(fa, 500)
#' plot(s)
#' }
#'@export
streams <- function(x, threshold){
  whitebox::install_whitebox()
  streams  <- tempfile(pattern = "streams", fileext = ".tif")
  wbt_extract_streams(
    flow_accum = terra::sources(x),
    output = streams,
    threshold = threshold)
  return(terra::rast(streams))
}
