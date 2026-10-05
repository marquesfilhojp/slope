# elevr

This function provides access to global raster elevation data from the
OpenTopography API.

## Usage

``` r
elevr(dem, aoi, api_key, output_file)
```

## Arguments

- dem:

  Currently supports: "SRTMGL3", "SRTMGL1", "SRTMGL1_E", "AW3D30",
  "AW3D30_E", "SRTM15Plus", "NASADEM", "COP30", "COP90", "EU_DTM",
  "GEDI_L3", "GEBCOIceTopo", "GEBCOSubIceTopo", "CA_MRDEM_DTM",
  "CA_MRDEM_DSM", "ANADEM", "GEDTM30" from the OpenTopography API global
  datasets.

- aoi:

  Defines the area of interest to crop/bound the elevation data, in
  \*sf\* format

- api_key:

  OpenTopography API key

- output_file:

  File path to save the elevation data in raster format

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
library(slope)
aoi <- sf::read_sf('ex/aoi.shp')
dem <- slope::elevr('GEDTM30', aoi, api_key, 'ex/dem.tif')
plot(dem)
} # }
```
