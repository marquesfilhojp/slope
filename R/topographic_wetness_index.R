#'Topographic Wetness Index
#'
#'Calculates Topographic Wetness Index, based on Beven and Kirkby (1979).
#'
#'@param x Input DEM raster
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'twi <- slope::topographic_wetness_index(dem, 'EPSG:5880', 'sca')
#'plot(twi)
#'}
#'@export
topographic_wetness_index <- function(x, crs, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else{
  x <- x|>
    terra::project(crs)
  slope <- x|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = 'radians', metrics = 'qslope')

  in_dem   <- tempfile(pattern = "dem", fileext = ".tif")
  out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
  out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
  out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")

  terra::writeRaster(x, in_dem, overwrite = T)

  whitebox::wbt_flow_accumulation_full_workflow(dem = in_dem,
                                      out_dem = out_dem,
                                      out_pntr = out_pntr,
                                      out_accum = out_accum,
                                      out_type = type)

  twi <- log(terra::rast(out_accum) / slope)
  names(twi) <- "topographic_wetness_index"

  return(twi)
  }
}
