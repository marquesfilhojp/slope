#'Geomorphic Change Detection
#'
#'Detects geomorphic change detection (DEMs of Difference) based in Wheathon et al. (2010).
#'
#'@param z_actual Input DEM raster file in second moment in time, using the same Earth Gravitational Model (EGM) for reduction in vertical error.
#'@param z_dem Input DEM raster file in first moment in time,  using the same Earth Gravitational Model (EGM) for reduction in vertical error.
#'@param crs Input geodesic reference systems.
#'@param type Choice between deposition [0] or erosion [1].
#'
#'@examples
#'\dontrun{
#' library(terra)
#' z2 <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' z1 <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' gcd <- slope::geomorphic_change_detection(z_actual, z_dem, 'EPSG:5880', 1)
#' plot(gcd)
#' }
#'@export
geomorphic_change_detection <- function(z_actual, z_dem, crs, type){
  if(missing(z_actual) || is.null(z_actual) || !inherits(z_actual, "SpatRaster")){
    stop("Argument 'z_actual' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(missing(z_dem) || is.null(z_dem) || !inherits(z_dem, "SpatRaster")){
    stop("Argument 'z_dem' must be provided and inherit from class 'SpatRaster'.", call. = FALSE)
  } else if(terra::crs(z_actual) != terra::crs(z_dem)){
    stop("Coordinate reference systems (CRS) of 'z_actual' and 'z_dem' do not match.", call. = FALSE)
  } else if(missing(type) || is.null(type) || !is.numeric(type)){
    stop("Argument 'type' must be provided and be numeric (0 for deposition, 1 for erosion).", call. = FALSE)
  } else{
    z_actual <- z_actual |>
      terra::project(crs)
    z_dem <- z_dem |>
      terra::project(crs)
    z_dem <- terra::resample(z_dem, z_actual, method = "bilinear")
    dod <- z_actual - z_dem

    if(type == 0){
      dod_p <- terra::as.points(dod) |>
        sf::st_as_sf()
      colnames(dod_p) <- c('z', 'geometry')
      height <- subset(dod_p, dod_p$z > 0)
      area <- as.numeric(terra::res(dod))[[1]] ** 2
      volume <- list()
      for(i in 1:nrow(height)){
        volume[[i]] <- height$z[i] * area
      }
      z_volume <- sum(unlist(volume), na.rm = TRUE) |>
        round(2)
      gcd <- terra::ifel(dod > 0, dod, 0)
    } else if(type == 1){
      dod_p <- terra::as.points(dod) |>
        sf::st_as_sf()
      colnames(dod_p) <- c('z', 'geometry')
      height <- subset(dod_p, dod_p$z < 0)
      area <- as.numeric(terra::res(dod))[[1]] ** 2
      volume <- list()
      for(i in 1:nrow(height)){
        volume[[i]] <- height$z[i] * area
      }
      z_volume <- sum(unlist(volume), na.rm = TRUE) |>
        round(2) * -1
      gcd <- terra::ifel(dod < 0, dod, 0)
    } else{
      stop("Choice between type [0] deposition or [1] erosion")
    }

    message(paste(z_volume, "m³"))
    return(gcd)
  }
}
