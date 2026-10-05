# Sediment Connectivity

Calculates sediment connectivity, based in Borelli et al. (2008).

## Usage

``` r
sediment_connectivity(x, c, w, flow_acc, flow_path)
```

## Arguments

- x:

  Input DEM raster

- c:

  C Factor reclassified based in Revised Equation Soil Loss Equation

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
c <- terra::rast(system.file("ex/lulc.tif", package = "terra"))
flow_acc <- terra:rast(system.file("ex/accum.tif", package = "terra"))
flow_path <- terra:rast(system.file("ex/flow_path.tif", package = "terra"))
sc <- slope::sediment_connectivity(dem, 5, fa, fp)
plot(sc)
} # }
```
