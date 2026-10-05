# Slope Forms

Detects the nine landform elements based on Dikau (1989).

## Usage

``` r
slopeforms(x, w, crs)
```

## Arguments

- x:

  Input DEM raster file.

- w:

  Number of cells for the window size

- crs:

  Coordinate reference system (e.g., 'EPSG:5880')

## Details

Each code refers to a specific pattern of slope forms:

- `11`: Concave-Concave slope (hollows).

- `12`: Concave-Concave slope.

- `13`: Concave-Convex slope.

- `21`: Concave-Straight slope.

- `22`: Straight-Straight slope.

- `23`: Convex-Straight slope.

- `31`: Concave-Convex slope.

- `32`: Straight-Convex slope.

- `33`: Convex-Convex slope.

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
slope_forms <- slope::slopeforms(dem, 7, 'EPSG:5880')
plot(slope_forms)
} # }
```
