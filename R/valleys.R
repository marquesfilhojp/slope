#'Valleys
#'
#' Detects different types of valleys, based on Silveira and Silveira (2020).
#' The primary difference is the use of a rectangular local neighborhood shape instead
#' of a circular one, in calculus of Black Top Hat (BTW) (Rodriguez et al. 2002).
#' For more satisfactory results, it is recommended to define the
#' moving window based on the minimum mappable area and function fill()
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param type Numeric. Each number represents a specific landform, for example: (1) Flat-bottomed Valleys, (2) Open Valleys, and (3) Incised Valleys
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#' dem_fill <- slope::fill(dem, system.file("ex/fill.tif'))
#' v <- slope::valleys(dem, 7, 3)
#' plot(v)
#'@export
valleys <- function(x, sp_range, c){
  x <- terra::rast(terra::sources(x))
  minmax <- terra::focal(x, sp_range, 'max')|>
    terra::focal(sp_range, 'min')
  bth <- minmax - x
  fa <- terra::terrain(x, v = 'flowdir', neighbors = 8, unit = 'degrees')|>
    terra::flowAccumulation()
  k <- terra::cellSize(fa, unit = 'm')
  a <- (fa* k/1000000)
  ac <- terra::crop(a, x, mask = T)
  sd <- as.numeric(terra::stdev(bth))
  if(c == 1){
    v <- terra::ifel(ac > 1 & bth < sd, 1, 0)
  } else if (c == 2) {
    v <- terra::ifel(ac > 1 & bth > 1 & bth < (3 * sd), 1, 0)
    v <- terra::ifel(ac > 1 & bth > sd & bth < (3 * sd), 1, 0)
  } else if (c == 3){
    v <- terra::ifel(ac > 1 & bth > (3 * sd), 1, 0)
  } else{
    print('Parameter condition is null or different of the pattern')
  }

  return(v)
}
