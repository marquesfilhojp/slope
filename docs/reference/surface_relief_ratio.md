# Surface Relief Ratio

Calculates Surface Relief Ratio, based on Berry (2002).

## Usage

``` r
surface_relief_ratio(x, w)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
srr <- slope::surface_relief_ratio(dem, 7)
plot(srr)
} # }
```
