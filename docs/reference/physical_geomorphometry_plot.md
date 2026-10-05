# Physical Geomorphometry Plot

Calculates the percentages of slope forms for graphical visualization.

## Usage

``` r
physical_geomorphometry_plot(x)
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
pgv <- slope::physical_geomorphometry_plot(sf)
plot(pgv)
} # }
```
