#'Slope Forms
#'
#'Detects the nine landform elements based on Dikau (1989).
#'
#'@details Each code refers to a specific pattern of slope forms:
#'\itemize{
#'   \item \code{11}: Concave-Concave slope (hollows).
#'   \item \code{12}: Concave-Concave slope.
#'   \item \code{13}: Concave-Convex slope.
#'   \item \code{21}: Concave-Straight slope.
#'   \item \code{22}: Straight-Straight slope.
#'   \item \code{23}: Convex-Straight slope.
#'   \item \code{31}: Concave-Convex slope.
#'   \item \code{32}: Straight-Convex slope.
#'   \item \code{33}: Convex-Convex slope.
#'}
#'
#'@param x Input DEM raster file.
#'@param w Number of cells for the window size
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'slope_forms <- slope::slopeforms(dem, 7, 'EPSG:5880')
#'plot(slope_forms)
#'}
#'@export
slopeforms <- function(x, w, crs){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else{
  profc <- x|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "profc", na.rm = TRUE)|>
    terra::focal(w = w, fun = "mean", na.rm = TRUE)
  profc_samples <- terra::spatSample(profc, size = 1000, method = "random", na.rm = TRUE)|>
    unlist()|>
    as.numeric()
  classes <- classInt::classIntervals(profc_samples, n = 3, style = "quantile")
  m <- matrix(c(
    -Inf, classes$brks[2], 10,
    classes$brks[2], classes$brks[3], 20,
    classes$brks[3], Inf, 30),
    ncol = 3, byrow = T)
  profc_classes <- terra::classify(profc, m, include.lowest = T, brackets = TRUE)
  planc <- x|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = "degrees", metrics = "planc", na.rm = TRUE)|>
    terra::focal(w = w, fun = "mean", na.rm = T)
  planc_samples <- terra::spatSample(planc, size = 1000, method = "random", na.rm = TRUE)|>
    unlist()|>
    as.numeric()
  classes <-classInt::classIntervals(planc_samples, n = 3, style = "quantile")
  m <- matrix(c(
    -Inf, classes$brks[2], 1,
    classes$brks[2], classes$brks[3], 2,
    classes$brks[3], Inf, 3),
    ncol = 3, byrow = T)
  planc_classes <- terra::classify(planc, m, include.lowest = TRUE, brackets = TRUE)
  slopeforms <- profc_classes + planc_classes
  names(slopeforms) <- "slopeforms"
  return(slopeforms)
  }
}
