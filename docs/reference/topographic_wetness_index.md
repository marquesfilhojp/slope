# Topographic Wetness Index

Calculates Topographic Wetness Index, based on Beven and Kirkby (1979).

## Usage

``` r
topographic_wetness_index(x, crs, type)
```

## Arguments

- x:

  Input DEM raster

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- type:

  Flow accumulation calculation type: 'cells', 'sca', or 'ca'.

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
twi <- slope::topographic_wetness_index(dem, 'EPSG:5880', 'sca')
plot(twi)
} # }
```
