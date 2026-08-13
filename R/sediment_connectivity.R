#' Sediment Connectivity
#'
#'\strong{Sediment Connectivity}
#'
#'Calculates sediment connectivity, based in Borelli et al. (2008).
#'
#'@param x Input DEM raster file.
#'@param w C Factor reclassified based in Revised Equation Soil Loss Equation.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
#'@param fa Input Flow Accumulation raster file.
#'@param fp Input Flow Path raster file.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'w <- terra::rast(system.file("ex/lulc.tif", package = "terra"))
#'fa <- terra:rast(system.file("ex/accum.tif", package = "terra"))
#'fp <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
#'ic <- slope::sediment_connectivity(dem, 5, fa, fp)
#'plot(ic)
#'}
#'@export
sediment_connectivity <- function(x, w, sp_range, fa, fp){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !inherits(w, "SpatRaster")){
    stop("Argument 'w' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(fa) || is.null(fa) || !inherits(fa, "SpatRaster")){
    stop("Argument 'fa' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(fp) || is.null(fp) || !inherits(fp, "SpatRaster")){
    stop("Argument 'fp' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(!terra::same.crs(x, fa) || !terra::same.crs(x, fp) || !terra::same.crs(x, w)){
    stop("Input rasters 'x', 'w', 'fa', and 'fp' must have the same coordinate reference system (CRS).", call. = FALSE)
  } else{
    s <- x |>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
      tan()|>
      terra::clamp(lower = 0.001, upper = 1.0)
    mean_slope <- terra::focal(s, sp_range, 'mean')

    d_up <- w * mean_slope * sqrt(fa)
    d_dn <- fp / (w * s)

    ic <- log10(d_up / d_dn)
    names(ic) <- "ic"

    return(ic)
  }
}

