#'Roughness Concentration Index
#'
#'Calculates the Roughness Concentration Index (RCI) based on the methodology of Sampaio and Augustin (2014).
#'
#'@param x Input DEM raster file.
#'@param sp_range Number of neighbor cells for multiscalar analysis.
#'@param crs Input geodesic reference systems.
#'@param aoi Area of interest in spatvect.
#'@param unit Metrics units in square kilometers.
#'
#'@examples
#'\dontrun{
#'library(terra)
#'library(slope)
#'aoi <- terra:vect(system.file("ex/aoi.shp", package = "terra"))
#'dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
#'r <- slope::rci(dem, 300, 'EPSG:5880', aoi, 1000000)
#'plot(r)
#'}
#'@export
rci <- function(x, sp_range, crs, aoi, unit){
  if(missing(x) || is.null(x) || !inherits(x, "SpatRaster")){
    stop("Argument 'x' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(sp_range) || is.null(sp_range) || !is.numeric(sp_range)){
    stop("Argument 'sp_range' must be provided and be a numeric value.", call. = FALSE)
  } else if(missing(crs) || is.null(crs)){
    stop("Argument 'crs' must be provided.", call. = FALSE)
  } else if(missing(aoi) || is.null(aoi) || !inherits(aoi, "SpatVector")){
    stop("Argument 'aoi' must be provided and inherit from class 'SpatVector'.", call. = FALSE)
  } else if(missing(unit) || is.null(unit) || !is.numeric(unit)){
    stop("Argument 'unit' must be provided and be a numeric multiplier.", call. = FALSE)
  } else{
    x <- x |>
      terra::project(crs)|>
      terra::terrain('slope', neighbors = 8, unit = 'degrees')
    p <- terra::as.points(x)|>
      sf::st_as_sf()
    s <- sf::st_coordinates(p)
    j <- cbind.data.frame(s, p)
    y <- sf::st_as_sf(j, geometry = j$geometry)|>
      spatstat.geom::as.ppp()
    k <- spatstat.explore::density.ppp(y, sigma = sp_range, weights = y$marks$slope,
                                       at = 'pixel', leaveoneout = TRUE,
                                       kernel = "gaussian") / as.numeric(terra::ncell(x))
    m <- terra::rast(k)
    terra::crs(m) <- crs
    aoi_proj <- terra::project(aoi, crs)
    r <- terra::crop(m, aoi_proj, mask = TRUE)
    r <- terra::resample(r, x, 'bilinear') * unit
    names(r) <- 'rci'
    return(r)
  }
}
