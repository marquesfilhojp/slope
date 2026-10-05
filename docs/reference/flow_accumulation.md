# Flow Accumulation

Performs the flow accumulation in DEMs based on the
wbt_flow_accumulation_full_workflow() function (Lindsay, 2016) for
calculates sediment connectivity (Cavalli et al. 2013).

## Usage

``` r
flow_accumulation(x, type)
```

## Arguments

- x:

  Input DEM raster

- type:

  Flow accumulation calculation type: 'cells', 'sca', or 'ca'

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
fa <- slope::flow_accumulation(dem, 'sca')
plot(fa)
} # }
```
