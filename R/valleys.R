#'Valleys
#'
#'Detects different types of valleys, based on Silveira and Silveira (2020).
#'The primary difference is the use of a rectangular local neighborhood shape instead
#'of a circular one, in the calculation of Black Top Hat (BTH) (Rodriguez et al., 2002).
#'For more satisfactory results, it is recommended to define the
#'moving window based on the minimum mappable area and the fill() function.
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'@param type Each number represents a specific landform, for example: (1) Flat-bottomed valleys, (2) Open valleys, and (3) Incised valleys.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'dem_fill <- slope::fill(dem, system.file("ex/fill.tif'))
#'valleys <- slope::valleys(dem, 7, 3)
#'plot(valleys)
#'}
#'@export
valleys <- function(x, w, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be a numeric value (e.g., 1, 2, or 3).", call. = FALSE)
  } else{
  minmax <- terra::focal(x, w, 'max')|>
    terra::focal(w, 'min')
  bth <- minmax - x
  flow_acc <- terra::terrain(x, v = 'flowdir', neighbors = 8)|>
    terra::flowAccumulation()
  size <- terra::cellSize(flow_acc, unit = 'm')
  ac <- (flow_acc * size/1000000)
  sd <- as.numeric(terra::stdev(bth))
  if(type == 1){
    valley <- terra::ifel(ac > 1 & bth < sd, 1, NA)
    names(valley) <- "flat_bottomed_valleys"
  } else if (type == 2) {
    valley_1 <- terra::ifel(ac > 1 & bth > 1 & bth < (3 * sd), 1, 0)
    valley_2 <- terra::ifel(ac > 1 & bth > sd & bth < (3 * sd), 1, 0)
    valley <- terra::ifel((valley_1 + valley_2) > 0, 1, NA)
    names(valley) <- "open_valleys"
  } else if (type == 3){
    valley <- terra::ifel(ac > 1 & bth > (3 * sd), 1, NA)
    names(valley) <- "incised_valleys"
  } else{
    stop("Argument 'type' must be 1, 2, or 3.", call. = FALSE)
  }
  return(valley)
  }
}
