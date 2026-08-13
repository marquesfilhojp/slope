#'Transformation (Normalization) Slope
#'
#'Slope normalization, based in Csillik et al. (2015)
#'
#'@param x Input DEM raster file.
#'@param sp_range Numeric. Number of neighbor cells for multiscalar analysis.
#'@param lambda Numeric. Only type [1]
#'@param crs Input geodesic reference systems.
#'@param type Numeric. Choice between normalization based in Evans (1977) (2015) [0] or Csillik et al. (2015) [1].
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'tc <- slope::transformed_slope(dem, 7, 0.1, 'EPSG:5880', 1)
#'plot(tc)
#'}
#'@export
transformed_slope <- function(x, sp_range, lambda, crs, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(lambda) || is.null(lambda) || !is.numeric(lambda)){
    stop("Argument 'lambda' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided and be a valid coordinate reference system.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be numeric (0 for Evans (1977), 1 for Csillik et al. (2015)).", call. = FALSE)
  } else{
    if(type == 0){
      x <- x|>
        terra::project(crs)|>
        MultiscaleDTM::Qfit(w = c(3,3), unit = "radians", metrics = "slope", na.rm = TRUE)|>
        terra::focal(w = sp_range, fun = "mean", na.rm = TRUE)
      ts <- sqrt(sin(x))
      names(ts) <- "transformed_slope"
      return(ts)
    } else if(type == 1){
      x <- x|>
        terra::project(crs)|>
        MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "slope", na.rm = TRUE)|>
        terra::focal(w = sp_range, fun = "mean", na.rm = TRUE)
      ts <- (x ** lambda - 1)/lambda
      names(ts) <- "transformed_slope"
      return(ts)
    } else{
      stop("Invalid 'type'. Choose between Evans (1977) [0] or Csillik et al. (2015) [1].", call. = FALSE)
    }
  }
}

