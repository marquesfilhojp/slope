#'LS Factor
#'
#'Calculates LS Factor based in Bertoni and Lombardi Neto (1985) or Moore and Burch (1986).
#'
#'@param x Input DEM raster
#'@param type Flow accumulation calculation type: 'cells', 'sca', or 'ca'.
#'@param method [0] for Moore and Burch (1986) or [1] for Bertoni and Lombardi Neto (1985).
#'@param crs Coordinate reference systems
#'@param m Exponent of first equation
#'@param n Exponent of second equation
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
ls_factor <- function(x, type, method, crs, m, n){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.character(type)){
    stop("Argument 'type' must be provided and be a character string.", call. = FALSE)
  } else if(missing(method) || is.null(method) || !is.numeric(method)){
    stop("Argument 'method' must be provided and be numeric (0 or 1).", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(m) || is.null(m) || !is.numeric(m)){
    stop("Argument 'm' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(n) || is.null(n) || !is.numeric(n)){
    stop("Argument 'n' must be provided and be a numeric value.", call. = FALSE)
  } else{
    x <- x|>
      terra::project(crs)
    slope <- x|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = 'radians', metrics = 'qslope')
    slope_bl <- tan(slope) * 100

    in_dem   <- tempfile(pattern = "dem", fileext = ".tif")
    out_dem   <- tempfile(pattern = "dem_fill", fileext = ".tif")
    out_pntr  <- tempfile(pattern = "d8", fileext = ".tif")
    out_accum <- tempfile(pattern = "flow_accum", fileext = ".tif")

    terra::writeRaster(x, in_dem, overwrite = T)
    res <- terra::res(x)[1]|>
      as.numeric()

    whitebox::wbt_flow_accumulation_full_workflow(dem = in_dem,
                                        out_dem = out_dem,
                                        out_pntr = out_pntr,
                                        out_accum = out_accum,
                                        out_type = type)

    if(method == 0){
      ls <-  (m + 1) * (((terra::rast(out_accum) * res)/22.13)**m) * ((sin(slope)/0.0896)**n)
      names(ls) <- "ls"
    } else if(method == 1){
      ls <- 0.00984 * (terra::rast(out_accum)**m) * (slope_bl**n)
      names(ls) <- "ls"
    } else{
      stop("Invalid 'method'. Choose between Moore and Burch (1986) [0] or Bertoni and Lombardi Neto (1985) [1].", call. = FALSE)
    }

    return(ls)
  }
}
