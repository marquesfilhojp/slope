#'Ridges and Tops
#'
#'Detects different types of ridges and tops, based on Silveira and Silveira (2020).
#'The primary difference is the use of a rectangular local neighborhood shape instead
#'of a circular one, in the calculation of the White Top Hat (WTH) (Rodriguez et al., 2002).
#'For more satisfactory results, it is recommended to define the
#'moving window based on the minimum mappable area.
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'@param type Each number represents a specific landform, for example: (1) Convex hilltops and Interfluves, (2) Sharp crests, and (3) Ridges
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'r <- slope::ridges_tops(dem, 7, 1)
#'plot(r)
#'}
#'@export
ridges_tops <- function(x, w, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be a numeric value (e.g., 1, 2, or 3).", call. = FALSE)
  } else{
  maxmin <-  terra::focal(x, w, 'min')|>
    terra::focal(w, 'max')
  wth <- x - maxmin
  area <- terra::project(dem, 'EPSG:5880')|>
    terra::expanse()/1000000
  area_km2 <- as.numeric(area$area)
  sd <- as.numeric(terra::global(wth, "sd", na.rm = TRUE)[1, 1])
  if(type == 1){
    r <- terra::ifel(wth > (1 * sd), 1, 0)
    names(r) <- "convex_hilltops"
  } else if(type == 2) {
    r <- terra::ifel(wth > (6 * sd), 1, 0)
    names(r) <- "sharp_crests"
  } else if(type == 3) {
    r <- terra::ifel(wth > (2 * sd) & area_km2 > 1, 1, 0)
    names(r) <- "ridges"
  } else{
    stop("Argument 'type' must be 1, 2, or 3.", call. = FALSE)
  }
  return(r)
  }
}
