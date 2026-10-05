#'Streams
#'
#'Identification of streams in DEMs based on the wbt_extract_streams() function (Lindsay, 2016) to calculate sediment connectivity (Cavalli et al., 2013).
#'
#'@param x Input Flow Accumulation raster
#'@param threshold Threshold value for stream extraction
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'flow_acc <- terra::rast(system.file("ex/accum.tif", package = "terra"))
#'streams <- slope::streams(flow_acc, 500)
#'plot(streams)
#'}
#'@export
streams <- function(x, threshold){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(threshold) || is.null(threshold) || !is.numeric(threshold)){
    stop("Argument 'threshold' must be provided and be a numeric value.", call. = FALSE)
  } else{
  whitebox::install_whitebox()
  streams  <- tempfile(pattern = "streams", fileext = ".tif")
  wbt_extract_streams(
    flow_accum = terra::sources(x),
    output = streams,
    threshold = threshold)
  return(terra::rast(streams))
  }
}
