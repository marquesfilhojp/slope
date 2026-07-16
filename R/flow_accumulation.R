# 'flow accumulation
#'
#'\strong Flow Accumulation
#'
#'Performs the flow accumulation in DEMs based on the wbt_flow_accumulation_full_workflow() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input DEM raster file.
#'@param type Float. 'cells', 'sca' and 'ca'.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' fa <- slope::flow_accumulation(dem, 'sca')
#' plot(fa)
#'@export
flow_accumulation <- function(x, type){
  whitebox::install_whitebox()
  out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
  out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
  out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")
  wbt_flow_accumulation_full_workflow(dem = terra::sources(x),
                                      out_dem = out_dem,
                                      out_pntr = out_pntr,
                                      out_accum = out_accum,
                                      out_type = type)
  return(terra::rast(out_accum))
}
