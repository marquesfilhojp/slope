#'Roughness Sediment Connectivity
#'
#'Calculates sediment connectivity, based in Cavalli et al. (2013).
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'@param flow_acc Input Flow Accumulation raster
#'@param flow_path Input Flow Path raster
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'flow_acc <- terra:rast(system.file("ex/accum.tif", package = "terra"))
#'flow_path <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
#'rsc <- slope::roughness_sediment_connectivity(dem, 5, fa, fp)
#'plot(rsc)
#'}
#'@export
roughness_sediment_connectivity <- function(x, w, flow_acc, flow_path){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(flow_acc) || is.null(flow_acc) || !inherits(flow_acc, "SpatRaster")){
    stop("Argument 'flow_acc' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(flow_path) || is.null(flow_path) || !inherits(flow_path, "SpatRaster")){
    stop("Argument 'flow_path' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(terra::crs(x) != terra::crs(flow_acc) || terra::crs(x) != terra::crs(flow_path)){
    stop("Input rasters 'x', 'flow_acc', and 'flow_path' must have the same coordinate reference system (CRS).", call. = FALSE)
  } else{
  slope_angle <- x |>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
    tan()|>
    terra::clamp(lower = 0.001, upper = 1.0)

  smoothed_dem <- terra::focal(x, w = w, 'mean')
  residual_dem <- x - smoothed_dem

  r <- terra::focal(residual_dem, w, 'sd')|>
    terra::clamp(lower = 0.001)
  r_max <- log(terra::focal(r, w = w, 'max'))|>
    terra::clamp(lower = 0.001)
  r_min <- log(terra::focal(r, w = w, 'min'))|>
    terra::clamp(lower = 0.001)

  logr <- log(r)
  r1 <- logr - r_min
  r1 <- terra::clamp(r1, lower = 0.001)
  r2 <- r_max - r_min
  r2 <- terra::clamp(r2, lower = 0.001)
  w_r <- 1 - (r1 / r2)
  w_r <- terra::clamp(w, lower = 0.001, upper = 1.0)

  d_up <- w_r * s * sqrt(fa)
  d_dn <- fp / (w_r * s)
  rsc <- log10(d_up / d_dn)

  names(rsc) <- "roughness_sediment_connectivity"
  return(rsc)
  }
}
