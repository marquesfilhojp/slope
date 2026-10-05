#'Slider
#'
#'Detects debris flow based on the identification of hollows and critical slope thresholds.
#'
#'@param x Input DEM raster
#'@param w Number of cells for the window size
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'@param min_slope Minimum slope angle
#'@param max_slope Maximum slope angle
#'@param type Concave-concave slope (hollows), referring to code 11, see details in slopeforms
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#'slider <- slope::slider(dem, 7, 'EPSG:5880', 21, 25, 11)
#'plot(slider)
#'}
#'@export
slider <- function(x, sp_range, crs, less_int_slope, more_int_slope, c){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(min_slope) || is.null(min_slope) || !is.numeric(min_slope)){
    stop("Argument 'min_slope' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(max_slope) || is.null(max_slope) || !is.numeric(max_slope)){
    stop("Argument 'max_slope' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be a numeric value.", call. = FALSE)
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
  slope_angle <- x|>
    terra::project(crs)|>
    MultiscaleDTM::Qfit(w = c(3,3), unit = 'degrees', metrics = 'qslope')
  sf <- terra::ifel(slopeforms <= type, 1, NA) |>
    terra::as.polygons()|>
    sf::st_as_sf()|>
    subset(slopeforms == 1)|>
    terra::vect()|>
    terra::disagg()
  zonal <- terra::zonal(x = slope_angle, z = sf, fun = 'mean', as.raster = TRUE, na.rm = TRUE)
  slider <- terra::ifel(zonal >= min_slope & hs <= max_slope, 1, NA)
  names(slider) <- "slider"
  return(slider)
  }
}
