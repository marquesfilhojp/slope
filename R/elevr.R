#'elevr
#'
#'This function provides access to global raster elevation data from the OpenTopography API.
#'
#'@param dem_type Currently supports "SRTMGL3", "SRTMGL1", "SRTMGL1_E", "AW3D30", "AW3D30_E", "SRTM15Plus", "NASADEM", "COP30", "COP90", "EU_DTM", "GEDI_L3", "GEBCOIceTopo", "GEBCOSubIceTopo", "CA_MRDEM_DTM", "CA_MRDEM_DSM", "ANADEM", "GEDTM30" from the OpenTopography API global datasets.
#'@param aoi Defines the area of interest to crop/bound the elevation data, in *sf* format.
#'@param proj Performs geodesic reference frame transformations and projective transformations. Default is NULL.
#'@param api_key The OpenTopography API key.
#'@param output_file File path to save the elevation data in raster format.
#'
#'@examples
#'\dontrun{
#'library(pacman)
#'p_load(sf, slope, terra)
#'aoi <- sf::read_sf('ex/aoi.shp')
#'data <- slope::elevr('GEDTM30', aoi, 'EPSG:5880', api_key, 'ex/dem.tif')
#'plot(data)
#'}
elevr <- function(dem_type, aoi, proj, api_key, output_file){
  y <- aoi|>
    sf::st_transform('EPSG:4326')|>
    sf::st_bbox()
  xmin <- as.numeric(y[1])
  ymin <- as.numeric(y[2])
  xmax <- as.numeric(y[3])
  ymax <- as.numeric(y[4])
  req <- httr2::request('https://portal.opentopography.org/API/globaldem')|>
    httr2::req_url_query(demtype = dem_type , south = ymin , north = ymax, west = xmin, east = xmax ,
                         outputFormat = 'GTiff', API_Key = api_key)
  data <- req|>
    httr2::req_perform(path = output_file)
  path_file <- normalizePath(dirname(output_file), winslash = "/")
  file <- basename(output_file)
  dem_file <- file.path(path_file, file)
  if(is.null(proj)){
    y <- aoi|>
      terra::vect()
    dem <- terra::rast(dem_file)|>
      terra::crop(y, mask = T)
    return(dem)
  }
  else {
    x <- aoi|>
      sf::st_transform(proj)|>
      terra::vect()
    dem <- terra::rast(dem_file)|>
      terra::project(proj)|>
      terra::crop(x, mask = T)
    return(dem)
  }
}
