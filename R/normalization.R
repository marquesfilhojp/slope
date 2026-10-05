#'Transformation (Normalization)
#'
#'Normalization of Land Surface Parameters (LSPs), based Huang et al. (2021)
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'ni <- slope::normalization(dem, 7)
#'plot(ni)
#'}
#'@export
normalization <- function(x, w){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else{
  max <- x|>
    terra::focal(w, fun = 'max', na.rm = F)
  min <- x|>
    terra::focal(w, fun = 'min', na.rm = F)
  ni <- (x - min)/(max - min)
  names(ni) <- paste0(names(x), "_norm")
  return(ni)
  }
}
