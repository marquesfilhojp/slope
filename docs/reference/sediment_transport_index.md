# Sediment Transport Index

Calculates Sediment Transport Index, based in Moore and Burch (1986).

## Usage

``` r
sediment_transport_index(x, type, crs, m, n, res)
```

## Arguments

- x:

  Input DEM raster

- type:

  Flow accumulation calculation type: 'cells', 'sca', or 'ca'

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- m:

  Exponent of first equation

- n:

  Exponent of second equation

- res:

  Resolution of DEM

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
sti <- slope::topographic_wetness_index(dem, 'sca')
plot(sti)
} # }
```
