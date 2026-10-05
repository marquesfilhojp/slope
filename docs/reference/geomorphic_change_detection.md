# Geomorphic Change Detection

Detects geomorphic change detection (DEMs of Difference) based in
Wheathon et al. (2010).

## Usage

``` r
geomorphic_change_detection(z_actual, z_dem, crs, type)
```

## Arguments

- z_actual:

  Input DEM raster in second moment in time, using the same Earth
  Gravitational Model (EGM) for reduction in vertical error.

- z_dem:

  Input DEM raster in first moment in time, using the same Earth
  Gravitational Model (EGM) for reduction in vertical error.

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- type:

  Choice between deposition \[0\] or erosion \[1\]

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
z_actual <- terra::rast(system.file("ex/elev.tif", package = "terra"))
z_dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
gcd <- slope::geomorphic_change_detection(z_actual, z_dem, 'EPSG:5880', 1)
plot(gcd)
} # }
```
