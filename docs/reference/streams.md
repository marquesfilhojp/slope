# Streams

Identification of streams in DEMs based on the wbt_extract_streams()
function (Lindsay, 2016) to calculate sediment connectivity (Cavalli et
al., 2013).

## Usage

``` r
streams(x, threshold)
```

## Arguments

- x:

  Input Flow Accumulation raster

- threshold:

  Threshold value for stream extraction

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
flow_acc <- terra::rast(system.file("ex/accum.tif", package = "terra"))
streams <- slope::streams(flow_acc, 500)
plot(streams)
} # }
```
