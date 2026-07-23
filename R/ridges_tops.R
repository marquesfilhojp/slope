#' Ridges and Tops
#'
#'\strong{Ridges and Tops}
#'
#'Detects different types of Ridges and Tops, based on Silveira and Silveira (2020).
#'\code The primary difference is the use of a rectangular local neighborhood shape instead
#'\code of a circular one, in calculus of White Top Hat (WTH) (Rodriguez et al. 2002).
#'\code For more satisfactory results, it is recommended to define the
#'\code moving window based on the minimum mappable area.
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param type Numeric. Each number represents a specific landform, for example: (1) Convex Hilltops and Interfluves, (2) Sharp Crests, and (3) Ridges
#'
#'@examples
#'\dontrun{
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' r <- slope::ridges_tops(dem, 7, 1)
#' plot(r)
#' }
#'@export
ridges_tops <- function(x, sp_range, type){
  x <- terra::rast(terra::sources(x))
  maxmin <-  terra::focal(x, sp_range, 'min')|>
    terra::focal(sp_range, 'max')
  wth <- x - maxmin
  area <- terra::project(dem, 'EPSG:5880')|>
    terra::expanse()/1000000
  area_km2 <- as.numeric(area$area)
  sd <- as.numeric(terra::global(wth, "sd", na.rm = TRUE)[1, 1])
  if(type == 1){
    r <- terra::ifel(wth > (1 * sd), 1, 0)
  } else if(type == 2) {
    r <- terra::ifel(wth > (6 * sd), 1, 0)
  } else if(type == 3) {
    r <- terra::ifel(wth > (2 * sd) & area_km2 > 1, 1, 0)
  } else{
    print('Parameter condition is null or different of the pattern')
  }
  return(r)
}
