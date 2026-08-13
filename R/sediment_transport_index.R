#'Sediment Transport Index
#'
#'Calculates Sediment Transport Index, based in Moore and Burch (1986).
#'
#'@param x Input DEM raster file.
#'@param type Float. 'cells', 'sca' and 'ca'.
#'@param m Float. Exponent of first equation.
#'@param n Float. Exponent of second equation.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' twi <- slope::topographic_wetness_index(dem, 'sca')
#' plot(twi)
#'@export
sediment_transport_index <- function(x, type, m, n){
  slope <- x|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = 'radians', metrics = 'qslope')
  out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
  out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
  out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")
  wbt_flow_accumulation_full_workflow(dem = terra::sources(x),
                                      out_dem = out_dem,
                                      out_pntr = out_pntr,
                                      out_accum = out_accum,
                                      out_type = type)
  sti <- (out_accum/22.13)**m * (slope/0.0896)**n
  return(sti)
}
