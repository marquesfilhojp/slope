#'LS Factor
#'
#'Calculates LS Factor based in Bertoni and Lombardi Neto (1985) or Moore and Burch (1986).
#'
#'@param x Input DEM raster file.
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'.
#'@param method [0] for Moore and Burch (1986) or [1] for Bertoni and Lombardi Neto (1985).
#'@param res Resolution
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'ls <- slope::ls_factor(dem, 'sca')
#'plot(ls)
#'}
#'@export
ls_factor <- function(x, type, method, res){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else if(missing(method) || is.null(method) || !is.numeric(method)){
    stop("Argument 'method' must be provided and be numeric (0 or 1).", call. = FALSE)
  } else if(missing(res) || is.null(res) || !is.numeric(res)){
    stop("Argument 'res' must be provided and be a numeric value.", call. = FALSE)
  } else{
    slope_mb <- x|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = 'radians', metrics = 'qslope')
    slope_bl <- tan(slope_mb) * 100
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

    if(method == 0){
      ls <- (accum_rast * res/22.13)**0.4 * (slope_mb/0.0896)**1.3
      names(ls) <- "ls"
    } else if(method == 1){
      ls <- 0.00984 * ((accum_rast * res) ** 0.63) * (slope_bl ** 1.18)
      names(ls) <- "ls"
    } else{
      stop("Invalid 'method'. Choose between Moore and Burch (1986) [0] or Bertoni and Lombardi Neto (1985) [1].", call. = FALSE)
    }

    return(ls)
  }
}
