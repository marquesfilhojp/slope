#' Sediment Connectivity
#'
#'\strong{Sediment Connectivity}
#'
#'Calculates sediment connectivity, based in Borelli et al. (2008).
#'
#'@param x Input DEM raster file.
#'@param w C Factor reclassified based in Revised Equation Soil Loss Equation.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param fa Input Flow Accumulation raster file.
#'@param fp Input Flow Path raster file.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' w <- terra::rast(system.file("ex/lulc.tif", package = "terra"))
#' fa <- terra:rast(system.file("ex/accum.tif", package = "terra"))
#' fp <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
#' ic <- slope::sediment_connectivity(dem, 5, fa, fp)
#' plot(ic)
#'@export
sediment_connectivity <- function(x, w, sp_range, fa, fp){
  s <- x |>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
    tan()|>
    terra::clamp(lower = 0.005, upper = 1.0)
  mean_slope <- terra::focal(s, sp_range, 'mean')
  d_up <- w * mean_slope * sqrt(fa)
  d_dn <- fp / (w * s)
  ic <- log10(d_up / d_dn)
  return(ic)
}
