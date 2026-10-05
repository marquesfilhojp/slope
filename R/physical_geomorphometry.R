#'Physical Geomorphometry
#'
#'Calculates the area and percentages of slope forms for tabular visualization.
#'
#'@param x Input slopeforms raster
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'sf <- terra::rast('ex/slopeforms.tif', package = "terra")
#'pg <- slope::physical_geomorphometry(sf)
#'plot(pg)
#'}
#'@export
physical_geomorphometry <- function(x){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else{
  sf <- x|>
    terra::as.polygons()|>
    sf::st_as_sf()|>
    spatialEco::sf_dissolve('slopeforms')
  area <- sf::st_area(sf)/1000000|>
    as.numeric()
  percent <- area * 100/sum(area)
  slope_forms <- data.frame(Code = c(11, 12, 13, 21, 22, 23, 31, 32, 33),
                      Slopes = c('Concave-Concave', 'Straight-Concave', 'Convex-Concave',
                                 'Concave-Straight', 'Straight-Straight', 'Convex-Straight',
                                 'Concave-Convex', 'Straight-Convex', 'Convex-Convex'),
                      Area = round(area, 2)|> as.numeric(), Percent = round(percent, 2)|> as.numeric())

  return(slope_forms)
  }
}
