#'Elevr
#'
#'This function provides access to global raster elevation data from the OpenTopography API.
#'
#'@param dem Currently supports: "SRTMGL3", "SRTMGL1", "SRTMGL1_E", "AW3D30", "AW3D30_E",
#'"SRTM15Plus", "NASADEM", "COP30", "COP90", "EU_DTM", "GEDI_L3", "GEBCOIceTopo", "GEBCOSubIceTopo",
#'"CA_MRDEM_DTM", "CA_MRDEM_DSM", "ANADEM", "GEDTM30" from the OpenTopography API global datasets.
#'@param aoi Defines the area of interest to crop/bound the elevation data, in *sf* format
#'@param api_key OpenTopography API key
#'@param output_file File path to save the elevation data in raster format
#'
#'@examples
#'\dontrun{
#'library(sf)
#'library(slope)
#'aoi <- sf::read_sf('ex/aoi.shp')
#'dem <- slope::elevr('GEDTM30', aoi, api_key, 'ex/dem.tif')
#'plot(dem)
#'}
#'@export
elevr <- function(dem, aoi, api_key, output_file){
  if(missing(dem) || is.null(dem) || !is.character(dem)){
    stop("Argument 'dem' must be provided and be a character string.", call. = FALSE)
  } else if(missing(aoi) || is.null(aoi) || !inherits(aoi, "sf")){
    stop("Argument 'aoi' must be provided and inherit from class 'sf'.", call. = FALSE)
  } else if(missing(api_key) || is.null(api_key) || !is.character(api_key)){
    stop("Argument 'api_key' must be provided and be a character string.", call. = FALSE)
  } else if(missing(output_file) || is.null(output_file) || !is.character(output_file)){
    stop("Argument 'output_file' must be provided and be a character string.", call. = FALSE)
  } else{
  y <- aoi|>
    sf::st_transform('EPSG:4326')|>
    sf::st_bbox()
  xmin <- as.numeric(y[1])
  ymin <- as.numeric(y[2])
  xmax <- as.numeric(y[3])
  ymax <- as.numeric(y[4])
  req <- httr2::request('https://portal.opentopography.org/API/globaldem')|>
    httr2::req_url_query(demtype = dem , south = ymin , north = ymax, west = xmin, east = xmax ,
                         outputFormat = 'GTiff', API_Key = api_key)
  data <- req|>
    httr2::req_perform(path = output_file)
  path_file <- normalizePath(dirname(output_file), winslash = "/")
  file <- basename(output_file)
  dem_file <- file.path(path_file, file)
  x <- aoi|>
      sf::st_transform('EPSG:4326')|>
      terra::vect()
  dem <- terra::rast(dem_file)|>
      terra::project('EPSG:4326')|>
      terra::crop(x, mask = T)
  return(dem)
  }
}
