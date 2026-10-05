#'Sediment Transport Index
#'
#'Calculates Sediment Transport Index, based in Moore and Burch (1986).
#'
#'@param x Input DEM raster
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'@param m Exponent of first equation
#'@param n Exponent of second equation
#'@param res Resolution of DEM
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'sti <- slope::topographic_wetness_index(dem, 'sca')
#'plot(sti)
#'}
#'@export
sediment_transport_index <- function(x, type, crs, m, n, res){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(m) || is.null(m) || !is.numeric(m)){
    stop("Argument 'm' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(n) || is.null(n) || !is.numeric(n)){
    stop("Argument 'n' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(res) || is.null(res) || !is.numeric(res)){
    stop("Argument 'res' must be provided and be a numeric value.", call. = FALSE)
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

  sti <- ((terra::rast(out_accum) / 22.13)**m) * ((sin(slope) / 0.0896)**n)
  names(sti) <- "sti"

  return(sti)
  }
}
