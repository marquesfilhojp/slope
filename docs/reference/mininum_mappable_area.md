# Mininum Mappable Area

Calculates minimum mappable area.

## Usage

``` r
mininum_mappable_area(scale, res)
```

## Arguments

- scale:

  Cartographic scale

- res:

  Resolution of DEM.

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
print(dem)
mma <- slope::minimum_mappable_area(100000, 30)
} # }
```
