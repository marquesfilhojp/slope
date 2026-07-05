# 'Roughness Concentration Index
#'
#'\strong Roughness Concentration Index
#'
#'Calculates the Roughness Concentration Index (RCI) based on the methodology of Sampaio and Augustin (2014).
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param crs Input geodesic reference systems.
#'@param aoi Area of interest in spatvect.
#'
#'@examples
#' library(terra)
#' aoi <- terra:vect(system.file("ex/elev.shp", package = "terra"))
#' dem <- terra:rast(system.file("ex/elev.shp", package = "terra"))
#' r <- slope::rci(dem, 300, 'EPSG:5880', aoi)
#' plot(r)
#'@export
rci <- function(x, sp_range, crs, aoi){
  x <- terra::rast(terra::sources (x))|>
    terra::project(crs)|>
    terra::terrain('slope', neighbors = 8, unit = 'degrees')
  p <- terra::as.points(x)|>
    sf::st_as_sf()
  s <- sf::st_coordinates(p)
  j <- cbind.data.frame(s, p)
  y <- sf::st_as_sf(j, geometry = j$geometry)|>
    spatstat.geom::as.ppp()
  k <- spatstat.core::density.ppp(y, sigma = sp_range, weights = y$marks$slope,
                                  at = 'pixel', leaveoneout = TRUE,
                                  kernel = "gaussian")
  m <- terra::rast(k)
  terra::crs(m) <- "EPSG:5880"
  r <- terra::crop(m, aoi, mask = T)
  names(r) <- 'rci'
  return(r)}
