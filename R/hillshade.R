#'Hillshade
#'
#'Calculates the area and percentages of slope forms for tabular visualization.
#'
#'@param x Input slopeforms raster result.
#'@param w Moving window size for the median filter.
#'@param angle Illumination angle (altitude) in degrees.
#'@param direction Illumination direction (azimuth) in degrees.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'shade <- slope::hillshade(dem, 3, 45, 315)
#'plot(shade)
#'}
#'@export
hillshade <- function(x, w, angle, direction){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(angle) || is.null(angle) || is.numeric(angle)){
    stop("Argument 'angle' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(direction) || is.null(direction) || !is.numeric(direction)){
    stop("Argument 'direction' must be provided and be a numeric value.", call. = FALSE)
  } else{
  slope <- terra::terrain(x, v = "slope", neighbors = 8, unit = "radians")
  aspect <- terra::terrain(x, v = "aspect", neighbors = 8, unit = "radians")
  shade <- terra::shade(slope, aspect, angle = angle, direction = direction)|>
    terra::project('EPSG:4326')|>
    focal(w = w, fun = "median", na.rm = TRUE)
  return(shade)
  }
}
