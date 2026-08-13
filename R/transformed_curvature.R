#'Transformation (Normalization) Curvature
#'
#'Curvature normalization, based in Evans (1972) and Csillik et al. (2015)
#'
#'@param x Input DEM raster file.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
#'@param crs Input geodesic reference systems.
#'@param k Kurtosis close to 0.
#'@param type Choice between Profile Curvature [0] or Plan Curvature [1].
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'tc <- slope::transformed_curvature(dem, 7, 0.1, 'EPSG:5880', 1)
#'plot(tc)
#'}
#'@export
transformed_curvature <- function(x, sp_range, k, crs, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(k) || is.null(k) || !is.numeric(k)){
    stop("Argument 'k' must be provided and be a numeric scaling factor.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be numeric (0 for Profile Curvature, 1 for Plan Curvature).", call. = FALSE)
  } else{
    if(type == 0){
      x <- x|>
        terra::project(crs)|>
        MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "profc", na.rm = T)|>
        terra::focal(w = sp_range, fun = "mean", na.rm = T)
      tc <- atan(k * x)
      names(tc) <- "transformed_profc"
      return(tc)
    } else if(type == 1){
      x <- x|>
        terra::project(crs)|>
        MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "planc", na.rm = T)|>
        terra::focal(w = sp_range, fun = "mean", na.rm = T)
      tc <- atan(k * x)
      names(tc) <- "transformed_planc"
      return(tc)
    } else{
      stop("Invalid 'type'. Choose between Profile Curvature [0] or Plan Curvature [1].", call. = FALSE)
    }
  }
}
