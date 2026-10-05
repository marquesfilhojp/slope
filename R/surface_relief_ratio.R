#'Surface Relief Ratio
#'
#'Calculates Surface Relief Ratio, based on Berry (2002).
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
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
surface_relief_ratio <- function(x, w){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else{
  max <- x|>
    terra::focal(w, 'max')
  min <- x|>
    terra::focal(sp_range, 'min')
  mean <- x|>
    terra::focal(w, 'mean')
  srr <- (mean - min)/(max - min)
  names(srr) <- "surface_relief_ratio"
  return(srr)
  }
}
