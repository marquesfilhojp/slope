# Flow Path

Performs the flow path in DEMs based on the
wbt_downslope_distance_to_stream() function (Lindsay, 2016) for
calculates sediment connectivity (Cavalli et al. 2013).

## Usage

``` r
flow_path(x, y)
```

## Arguments

- x:

  Input DEM raster

- y:

  Input streams raster

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
streams <- terra::rast(system.file("ex/streams.tif", package = "terra"))
fp <- slope::flow_path(dem, s)
plot(fp)
} # }
```
