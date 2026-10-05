# Hillshade

Calculates shaded relief (hillshade) from a Digital Elevation Model
(DEM).

## Usage

``` r
hillshade(x, w, angle, direction)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

- angle:

  Illumination angle (altitude) in degrees

- direction:

  Illumination direction (azimuth) in degrees

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
shade <- slope::hillshade(dem, 3, 45, 315)
plot(shade)
} # }
```
