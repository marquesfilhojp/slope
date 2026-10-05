#'Sediment Connectivity
#'
#'Calculates sediment connectivity, based in Borelli et al. (2008).
#'
#'@param x Input DEM raster
#'@param c C Factor reclassified based in Revised Equation Soil Loss Equation
#'@param w Number of cells for the window size
#'@param flow_acc Input Flow Accumulation raster
#'@param flow_path Input Flow Path raster
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'c <- terra::rast(system.file("ex/lulc.tif", package = "terra"))
#'flow_acc <- terra:rast(system.file("ex/accum.tif", package = "terra"))
#'flow_path <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
#'sc <- slope::sediment_connectivity(dem, 5, fa, fp)
#'plot(sc)
#'}
#'@export
sediment_connectivity <- function(x, c, w, flow_acc, flow_path){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(c) || is.null(c) || !inherits(c, "SpatRaster")){
    stop("Argument 'c' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(flow_acc) || is.null(flow_acc) || !inherits(flow_acc, "SpatRaster")){
    stop("Argument 'flow_acc' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(flow_path) || is.null(flow_path) || !inherits(flow_path, "SpatRaster")){
    stop("Argument 'flow_path' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(terra::crs(x) != terra::crs(flow_acc) || terra::crs(x) != terra::crs(flow_path) || terra::crs(x) != terra::crs(c)){
    stop("Input rasters 'x', 'c', 'flow_acc', and 'flow_path' must have the same coordinate reference system (CRS).", call. = FALSE)
  } else{
    slope_angle <- x |>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
      tan()|>
      terra::clamp(lower = 0.001, upper = 1.0)
    mean_slope <- terra::focal(slope_angle, w, 'mean')

    d_up <- c * mean_slope * sqrt(flow_acc)
    d_dn <- fp / (c * slope_angle)

    sc <- log10(d_up / d_dn)
    names(sc) <- "sediment_connectivity"

    return(sc)
  }
}

