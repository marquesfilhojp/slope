#'Sediment Transport Index
#'
#'Calculates Sediment Transport Index, based in Moore and Burch (1986).
#'
#'@param x Input DEM raster file.
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'.
#'@param m Exponent of first equation.
#'@param n Exponent of second equation.
#'@param res Resolution
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
sediment_transport_index <- function(x, type, m, n, res){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else if(missing(m) || is.null(m) || !is.numeric(m)){
    stop("Argument 'm' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(n) || is.null(n) || !is.numeric(n)){
    stop("Argument 'n' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(res) || is.null(res) || !is.numeric(res)){
    stop("Argument 'res' must be provided and be a numeric value.", call. = FALSE)
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

  sti <- (accum_rast * res/22.13)**m * (slope/0.0896)**n
  names(sti) <- "sti"

  return(sti)
  }
}
