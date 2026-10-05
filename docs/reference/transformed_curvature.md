# Transformation (Normalization) Curvature

Curvature normalization based in Evans (1972) and Csillik et al. (2015)

## Usage

``` r
transformed_curvature(x, w, k, crs, type)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

- k:

  Kurtosis close to 0

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- type:

  Profile curvature \[0\] or Plan curvature \[1\]

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
tc <- slope::transformed_curvature(dem, 7, 0.1, 'EPSG:5880', 1)
plot(tc)
} # }
```
