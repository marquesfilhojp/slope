#' Transformation (Normalization) Slope
#'
#'\strong{Transformation (Normalization) Slope}
#'
#'Slope normalization, based in Csillik et al. (2015)
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param lambda Numeric. Only type [1]
#'@param crs Input geodesic reference systems.
#'@param type Numeric. Choice between normalization based in Evans (1977) (2015) [0] or Csillik et al. (2015) [1].
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' tc <- slope::transformed_slope(dem, 7, 0.1, 'EPSG:5880', 1)
#' plot(tc)
#' }
#'@export
transformed_slope <- function(x, sp_range, lambda, crs, type){
  if(type == 0){
    x <- x|>
      terra::project(crs)|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = T)|>
      terra::focal(w = sp_range, fun = "mean", na.rm = T)
    ts <- sqrt(sin(x))
    return(ts)
  } else if(type == 1){
    x <- x|>
      terra::project(crs)|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "slope", na.rm = T)|>
      terra::focal(w = sp_range, fun = "mean", na.rm = T)
    ts <- (x ** lambda - 1)/lambda
    return(ts)
  } else{
    print('Choice between Evans (1977) [0] or Csillik et al. (2015) [1]')
  }
}
