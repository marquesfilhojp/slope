#'Flow Accumulation
#'
#'Performs the flow accumulation in DEMs based on the wbt_flow_accumulation_full_workflow() function (Lindsay, 2016) for calculates sediment connectivity (Cavalli et al. 2013).
#'
#'@param x Input DEM raster file.
#'@param type 'cells', 'sca' and 'ca'.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'fa <- slope::flow_accumulation(dem, 'sca')
#'plot(fa)
#'}
#'@export
flow_accumulation <- function(x, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else{
  whitebox::install_whitebox()
  out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
  out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
  out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")
  whitebox::wbt_flow_accumulation_full_workflow(dem = terra::sources(x),
                                      out_dem = out_dem,
                                      out_pntr = out_pntr,
                                      out_accum = out_accum,
                                      out_type = type)
  return(terra::rast(out_accum))
  }
}
