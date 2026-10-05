# Roughness Concentration Index

Calculates the Roughness Concentration Index (RCI) based on the
methodology of Sampaio and Augustin (2014).

## Usage

``` r
rci(x, w, crs, aoi, unit)
```

## Arguments

- x:

  Input DEM raster file.

- w:

  Number of cells for the window size

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- aoi:

  Area of interest

- unit:

  Metrics units in square kilometers.

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
aoi <- terra:vect(system.file("ex/aoi.shp", package = "terra"))
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
rci <- slope::rci(dem, 300, 'EPSG:5880', aoi, 1000000)
plot(rci)
} # }
```
