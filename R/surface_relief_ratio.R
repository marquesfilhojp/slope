#'Surface Relief Ratio
#'
#'Calculates Surface Relief Ratio, based Berry (2002).
#'
#'@param x Input DEM raster file.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'srr <- slope::surface_relief_ratio(dem, 7)
#'plot(srr)
#'}
#'@export
surface_relief_ratio <- function(x, sp_range){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else{
  max <- x|>
    terra::focal(sp_range, 'max')
  min <- x|>
    terra::focal(sp_range, 'min')
  mean <- x|>
    terra::focal(sp_range, 'mean')
  srr <- (mean - min)/(max - min)
  return(srr)
  }
}
