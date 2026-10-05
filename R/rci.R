#'Roughness Concentration Index
#'
#'Calculates the Roughness Concentration Index (RCI) based on the methodology of Sampaio and Augustin (2014).
#'
#'@param x Input DEM raster file.
#'@param w Number of cells for the window size
#'@param crs Coordinate reference system (e.g., 'EPSG:5880')
#'@param aoi Area of interest
#'@param unit Metrics units in square kilometers.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'aoi <- terra:vect(system.file("ex/aoi.shp", package = "terra"))
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'rci <- slope::rci(dem, 300, 'EPSG:5880', aoi, 1000000)
#'plot(rci)
#'}
#'@export
rci <- function(x, w, crs, aoi, unit){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(w) || is.null(w) || !is.numeric(w)){
    stop("Argument 'w' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(aoi) || is.null(aoi) || (!inherits(aoi, "SpatVector") && !inherits(aoi, "sf"))){
    stop("Argument 'aoi' must be provided and inherit from class 'sf' or 'SpatVector'.", call. = FALSE)
  } else if(missing(unit) || is.null(unit) || !is.numeric(unit)){
    stop("Argument 'unit' must be provided and be a numeric multiplier.", call. = FALSE)
  } else{
    x <- terra::project(x, crs)
    slope <- x |>
      terra::terrain('slope', neighbors = 8, unit = 'degrees')
    slope_angle_points <- terra::as.points(x) |>
      sf::st_as_sf()
    coords <- sf::st_coordinates(slope_angle_points)
    dataset <- cbind.data.frame(slope, slope_angle_points)
    points <- sf::st_as_sf(dataset, geometry = dataset$geometry) |>
      spatstat.geom::as.ppp()
    k <- spatstat.explore::density.ppp(points, sigma = w, weights = points$marks$slope,
                                       at = 'pixel', leaveoneout = TRUE,
                                       kernel = "gaussian") / as.numeric(terra::ncell(x))
    data <- terra::rast(k)
    terra::crs(data) <- crs
    aoi_proj <- terra::project(terra::vect(aoi), crs)
    r <- terra::crop(data, aoi_proj, mask = TRUE)
    rci <- terra::resample(r, x, 'bilinear') * unit
    names(rci) <- 'rci'
    return(rci)
  }
}
