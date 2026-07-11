# 'slider
#'
#'\strong Debris Flow Prediction
#'
#'Detects debris flow based on the identification of hollows and critical slope thresholds.
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param crs Input geodesic reference systems.
#'@param less_int_slope Numeric. Minimum slope angle.
#'@param more_int_slope Numeric. Maximum slope angle.
#'@param c Concave-concave slope (hollows), referring to code 11, see details in slopeforms.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package="terra"))
#' sd <- slope::slider(dem, 7, 'EPSG:5880', 21, 25, 11)
#' plot(sd)
#'@export
slider <- function(x, sp_range, crs, less_int_slope, more_int_slope, c){
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
  xs <- terra::rast(terra::sources(x))|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = 'degrees', metrics = 'qslope')
  sf <- terra::ifel(slopeforms <= c, 1, 0) |>
    terra::as.polygons()|>
    sf::st_as_sf()|>
    subset(slopeforms == 1)|>
    terra::vect()|>
    terra::disagg()
  hs <- terra::zonal(x = xs, z = sf, fun = 'mean', as.raster = T, na.rm = T)
  slider <- terra::ifel(hs >= less_int_slope & hs <= more_int_slope, 1, 0)
  return(slider)}
