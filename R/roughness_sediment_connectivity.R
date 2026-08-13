#'Roughness Sediment Connectivity
#'
#'Calculates sediment connectivity where w is roughness, based in Cavalli et al. (2013).
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param fa Input Flow Accumulation raster file.
#'@param fp Input Flow Path raster file.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' fa <- terra:rast(system.file("ex/accum.tif", package = "terra"))
#' fp <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
#' ic <- slope::roughness_sediment_connectivity(dem, 5, fa, fp)
#' plot(ic)
#'@export
roughness_sediment_connectivity <- function(x, sp_range, fa, fp){
  s <- x |>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
    tan()|>
    terra::clamp(lower = 0.005, upper = 1.0)
  smoothed_dem <- terra::focal(x, w = sp_range, 'mean')
  residual_dem <- x - smoothed_dem
  r <- terra::focal(residual_dem, sp_range, 'sd')|>
    terra::clamp(lower = 0.001)
  r_max <- log(terra::focal(r, w = sp_range, 'max'))|>
    terra::clamp(lower = 0.001)
  r_min <- log(terra::focal(r, w = sp_range, 'min'))|>
    terra::clamp(lower = 0.001)
  logr <- log(r)
  r1 <- logr - r_min
  r1 <- terra::clamp(r1, lower = 0.001)
  r2 <- r_max - r_min
  r2 <- terra::clamp(r2, lower = 0.001)
  w <- 1 - (r1 / r2)
  w <- terra::clamp(w, lower = 0.001, upper = 1.0)
  d_up <- w * s * sqrt(fa)
  d_dn <- fp / (w * s)
  ic <- log10(d_up / d_dn)
  return(ic)
}
