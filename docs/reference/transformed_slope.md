# Transformation (Normalization) Slope

Slope normalization based in Csillik et al. (2015)

## Usage

``` r
transformed_slope(x, w, lambda, crs, type)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

- lambda:

  Only type \[1\] and different from zero

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- type:

  Normalization methods based on Evans (1977, 2015) \[0\] or Csillik et
  al. (2015) \[1\].

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
tc <- slope::transformed_slope(dem, 7, 0.1, 'EPSG:5880', 1)
plot(tc)
} # }
```
