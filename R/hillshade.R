# 'hillshade
#'
#'\strong Hillshade for slope patterns visualization
#'
#'Calculates the area and percentages of slope forms for tabular visualization.
#'
#'@param x Input slopeforms raster result.
#'@param w Numeric. Moving window size for the median filter.
#'@param angle Numeric. Illumination angle (altitude) in degrees.
#'@param direction Numeric. Illumination direction (azimuth) in degrees.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package="terra"))
#' shade <- slope::hillshade(dem, 3, 45, 315)
#' plot(shade)
hillshade <- function(x, w, angle, direction){
  slope <- terra::terrain(x, v = "slope", neighbors = 8, unit = "radians")
  aspect <- terra::terrain(x, v = "aspect", neighbors = 8, unit = "radians")
  shade <- terra::shade(slope, aspect, angle = angle, direction = direction)|>
    terra::project('EPSG:5880')|>
    focal(w = w, fun = "median", na.rm = TRUE)
  return(shade)
}
