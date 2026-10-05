# Dissection Index

Calculates the Dissection Index (DI) to detect spatial patterns of
terrain dissection, based on Evans (1972).

## Usage

``` r
dissection_index(x, w)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
di <- slope::dissection_index(dem, 7)
plot(di)
} # }
```
