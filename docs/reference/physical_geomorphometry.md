# Physical Geomorphometry

Calculates the area and percentages of slope forms for tabular
visualization.

## Usage

``` r
physical_geomorphometry(x)
```

## Arguments

- x:

  Input slopeforms raster

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
sf <- terra::rast('ex/slopeforms.tif', package = "terra")
pg <- slope::physical_geomorphometry(sf)
plot(pg)
} # }
```
