#'Transformation (Normalization)
#'
#'Performs normalization of Land Surface Parameters (LSPs), based Huang et al. (2021)
#'
#'@param x Input DEM raster file.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
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
normalization <- function(x, sp_range){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else{
  max <- x|>
    terra::focal(sp_range, fun = 'max', na.rm = F)
  min <- x|>
    terra::focal(sp_range, fun = 'min', na.rm = F)
  ni <- (x - min)/(max - min)
  names(ni) <- paste0(names(x), "_norm")
  return(ni)
  }
}
