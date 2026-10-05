# Roughness Index

Calculates Roughness Index, based in Trevisani and Cavalli (2016).

## Usage

``` r
roughness_index(x, sp_range)
```

## Arguments

- x:

  Input DEM raster

- w:

  w Number of cells for the window size

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
ri <- slope::roughness_index(dem, 5)
plot(ri)
} # }
```
