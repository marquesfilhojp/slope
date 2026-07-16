# 'Transformation (Normalization) Curvature
#'
#'\strong Transformation (Normalization) Curvature
#'
#'Curvature normalization, based in Evans (1972) and Csillik et al. (2015)
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param crs Numeric. Input geodesic reference systems.
#'@param k Numeric. Kurtosis close to 0.
#'@param type Numeric. Choice between Profile Curvature [0] or Plan Curvature [1].
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.shp", package = "terra"))
#' tc <- slope::transformed_curvature(dem, 7, 0.1, 'EPSG:5880', 1)
#' plot(tc)
#'@export
transformed_curvature <- function(x, sp_range, k, crs, type){
  if(type == 0){
    x <- x|>
      terra::project(crs)|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "profc", na.rm = T)|>
      terra::focal(w = sp_range, fun = "mean", na.rm = T)
    tc <- atan(k * x)
    return(tc)
  } else if(type == 1){
    x <- x|>
      terra::project(crs)|>
      MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "planc", na.rm = T)|>
      terra::focal(w = sp_range, fun = "mean", na.rm = T)
    tc <- atan(k * x)
    return(tc)
  } else{
    print('Choice between Profile Curvature [0] or Plan Curvature [1]')
  }
}
