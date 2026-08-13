#'Streams
#'
#'Performs identification of streams in DEMs based on the wbt_extract_streams() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input Flow Accumulation raster file.
#'@param threshold Extraction of streams.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'fa <- terra::rast(system.file("ex/accum.tif", package = "terra"))
#'s <- slope::streams(fa, 500)
#'plot(s)
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
