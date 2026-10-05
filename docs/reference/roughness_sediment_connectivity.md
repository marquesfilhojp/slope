# Roughness Sediment Connectivity

Calculates sediment connectivity, based in Cavalli et al. (2013).

## Usage

``` r
roughness_sediment_connectivity(x, w, flow_acc, flow_path)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

- flow_acc:

  Input Flow Accumulation raster

- flow_path:

  Input Flow Path raster

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
flow_acc <- terra:rast(system.file("ex/accum.tif", package = "terra"))
flow_path <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
rsc <- slope::roughness_sediment_connectivity(dem, 5, fa, fp)
plot(rsc)
} # }
```
