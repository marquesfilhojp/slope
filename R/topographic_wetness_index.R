#'Topographic Wetness Index
#'
#'Calculates Topographic Wetness Index, based in Beven and Kirbky (1979).
#'
#'@param x Input DEM raster file.
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'twi <- slope::topographic_wetness_index(dem, 'sca')
#'plot(twi)
#'}
#'@export
topographic_wetness_index <- function(x, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else{
  slope <- x|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = 'radians', metrics = 'qslope')
  out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
  out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
  out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")

  whitebox::wbt_flow_accumulation_full_workflow(dem = terra::sources(x),
                                      out_dem = out_dem,
                                      out_pntr = out_pntr,
                                      out_accum = out_accum,
                                      out_type = type)
  accum_rast <- terra::rast(out_accum)|>
    terra::clamp(lower = 0.001)

  twi <- log(accum_rast / slope)
  names(twi) <- "twi"

  return(twi)
  }
}
