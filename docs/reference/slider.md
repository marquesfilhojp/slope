# Slider

Detects debris flow based on the identification of hollows and critical
slope thresholds.

## Usage

``` r
slider(x, sp_range, crs, less_int_slope, more_int_slope, c)
```

## Arguments

- x:

  Input DEM raster

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

- w:

  Number of cells for the window size

- min_slope:

  Minimum slope angle

- max_slope:

  Maximum slope angle

- type:

  Concave-concave slope (hollows), referring to code 11, see details in
  slopeforms

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
slider <- slope::slider(dem, 7, 'EPSG:5880', 21, 25, 11)
plot(slider)
} # }
```
