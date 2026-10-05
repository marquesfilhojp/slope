#'Physical Geomorphometry Plot
#'
#'Calculates the percentages of slope forms for graphical visualization.
#'
#'@param x Input slopeforms raster
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'sf <- terra::rast('ex/slopeforms.tif', package = "terra")
#'pgv <- slope::physical_geomorphometry_plot(sf)
#'plot(pgv)
#'}
#'@export
physical_geomorphometry_plot <- function(x){
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
                      slopes = c('Concave-Concave', 'Straight-Concave', 'Convex-Concave',
                                 'Concave-Straight', 'Straight-Straight', 'Convex-Straight',
                                 'Concave-Convex', 'Straight-Convex', 'Convex-Convex'),
                      Area = round(area, 2)|> as.numeric(), Percent = round(percent, 2)|> as.numeric())

  colours <- c(
    "Concave-Concave"   = "#0000A0",
    "Straight-Concave"        = "#4169E1",
    "Convex-Concave"    = "#8A8AFF",
    "Concave-Straight"     = "#008000",
    "Straight-Straight"      = "#32CD32",
    "Convex-Straight"  = "#98FB98",
    "Concave-Convex"   = "#D10000",
    "Straight-Convex"        = "#FF8C00",
    "Convex-Convex"    = "#FFD700"
  )

  return(ggplot(slope_forms, aes(y = Slopes, x = Percent, fill = Slopes)) +
           ggplot2::geom_bar(stat = "identity", show.legend = FALSE)+
           ggplot2::geom_label(aes(label = Percent),
                      color = "white",
                      position = position_stack(vjust = 0.5),
                      show.legend = FALSE) +
           ggplot2::coord_polar(theta = "y")+
           ggplot2::scale_fill_manual(values = colours) +
           ggplot2::theme_classic()+
           ggplot2::xlab("Percent %") +
           ggplot2::ylab("Slope Forms"))
  }
}
