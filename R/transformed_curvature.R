#'Transformation (Normalization) Curvature
#'
#'Curvature normalization based in Evans (1972) and Csillik et al. (2015)
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'@param k Kurtosis close to 0
#'@param type Profile curvature [0] or Plan curvature [1]
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
transformed_curvature <- function(x, w, k, crs, type){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
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
        MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "profc", na.rm = TRUE)|>
        terra::focal(w = w, fun = "mean", na.rm = TRUE)
      tc <- atan(k * x)
      names(tc) <- "transformed_profc"
      return(tc)
    } else if(type == 1){
      x <- x|>
        terra::project(crs)|>
        MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "planc", na.rm = TRUE)|>
        terra::focal(w = w, fun = "mean", na.rm = TRUE)
      tc <- atan(k * x)
      names(tc) <- "transformed_planc"
      return(tc)
    } else{
      stop("Invalid 'type'. Choose between Profile Curvature [0] or Plan Curvature [1].", call. = FALSE)
    }
  }
}
