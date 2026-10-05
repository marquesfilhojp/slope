# Transformation (Normalization)

Normalization of Land Surface Parameters (LSPs), based Huang et al.
(2021)

## Usage

``` r
normalization(x, w)
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
ni <- slope::normalization(dem, 7)
plot(ni)
} # }
```
