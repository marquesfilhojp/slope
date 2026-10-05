#'Dissection Index
#'
#'Calculates the Dissection Index (DI) to detect spatial patterns of terrain dissection, based on Evans (1972).
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'di <- slope::dissection_index(dem, 7)
#'plot(di)
#'}
#'@export
dissection_index <- function(x, w){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'dem' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else{
  max <- x|>
    terra::focal(w, 'max')
  min <- x|>
    terra::focal(w, 'min')
  di <- (x - min)/(max - min)
  names(di) <- "dissection_index"
  return(di)
  }
}
