# Ridges and Tops

Detects different types of ridges and tops, based on Silveira and
Silveira (2020). The primary difference is the use of a rectangular
local neighborhood shape instead of a circular one, in the calculation
of the White Top Hat (WTH) (Rodriguez et al., 2002). For more
satisfactory results, it is recommended to define the moving window
based on the minimum mappable area.

## Usage

``` r
ridges_tops(x, sp_range, type)
```

## Arguments

- x:

  Input DEM raster

- type:

  Each number represents a specific landform, for example: (1) Convex
  hilltops and Interfluves, (2) Sharp crests, and (3) Ridges

- w:

  Number of cells for the window size

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
r <- slope::ridges_tops(dem, 7, 1)
plot(r)
} # }
```
