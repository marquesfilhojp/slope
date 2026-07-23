#' Slope Forms
#'
#'\strong{Slope Forms Patterns}
#'
#'Detects the nine landform elements based on Dikau (1989).
#'\code Each code refers to a specific pattern of slope forms.
#'
#'@details Each code refers to a specific pattern of slope forms:
#' \itemize{
#'   \item \code{11}: Concave-Concave slope (hollows).
#'   \item \code{12}: Concave-Concave slope.
#'   \item \code{13}: Concave-Convex slope.
#'   \item \code{21}: Concave-Straight slope.
#'   \item \code{22}: Straight-Straight slope.
#'   \item \code{23}: Convex-Straight slope.
#'   \item \code{31}: Concave-Convex slope.
#'   \item \code{32}: Straight-Convex slope.
#'   \item \code{33}: Convex-Convex slope.
#' }
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param crs Input geodesic reference systems.
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' sf <- slope::slopeforms(dem, 7, 'EPSG:5880')
#' plot(sf)
#' }
#'@export
slopeforms <- function(x, sp_range, crs){
  xx <- terra::rast(terra::sources(x))|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "profc", na.rm = T)|>
    terra::focal(w = sp_range, fun = "mean", na.rm = T)
  xs <- terra::spatSample(xx, size = 1000, method = "random", na.rm = T)|>
    unlist()|>
    as.numeric()
  xc <-classInt::classIntervals(xs, n = 3, style = "quantile")
  rx <- matrix(c(
    -Inf, xc$brks[2], 10,
    xc$brks[2], xc$brks[3], 20,
    xc$brks[3], Inf, 30),
    ncol = 3, byrow = T)
  xci <- terra::classify(xx, rx, include.lowest = T, brackets = T)
  xy <- terra::rast(terra::sources(x))|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "planc", na.rm = T)|>
    terra::focal(w = sp_range, fun = "mean", na.rm = T)
  ys <- terra::spatSample(xy, size = 1000, method = "random", na.rm = T)|>
    unlist()|>
    as.numeric()
  yc <-classInt::classIntervals(ys, n = 3, style = "quantile")
  ry <- matrix(c(
    -Inf, yc$brks[2], 1,
    yc$brks[2], yc$brks[3], 2,
    yc$brks[3], Inf, 3),
    ncol = 3, byrow = T)
  yci <- terra::classify(xy, ry, include.lowest = T, brackets = T)
  slopeforms <- xci + yci
  names(slopeforms) <- "slopeforms"
  return(slopeforms)}
