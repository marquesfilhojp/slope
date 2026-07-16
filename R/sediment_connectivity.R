#'Sediment Connectivity
#'
#'\strong Sediment Connectivity
#'
#'Calculates sediment connectivity, based in Cavalli et al. (2013)
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
#' ic <- slope::sediment_connectivity(dem, 7, fa, fp)
#' plot(ic)
sediment_connectivity <- function(x, sp_range, fa, fp){
  s <- x |>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)
  s <- terra::clamp(s, lower = 0.005, upper = 1)
  cell_area <- terra::res(x)[1] * terra::res(x)[2]
  fa_area <- fa * cell_area
  mean_dem <- terra::focal(x, sp_range, 'mean')
  residual <- x - mean_dem
  ri <- terra::focal(residual, sp_range, 'sd')
  ri_max <- as.numeric(terra::global(ri, "max", na.rm = TRUE)[1, 1])
  w <- 1 - (ri / ri_max)
  w <- terra::clamp(w, lower = 0.001, upper = 1)
  d_up <- w * s * sqrt(fa_area)
  d_dn <- fp / (w * s)
  ic <- log10(d_up / d_dn)
  return(ic)
}
