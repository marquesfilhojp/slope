# LS Factor

Calculates LS Factor based in Bertoni and Lombardi Neto (1985) or Moore
and Burch (1986).

## Usage

``` r
ls_factor(x, type, method, crs, m, n)
```

## Arguments

- x:

  Input DEM raster

- type:

  Flow accumulation calculation type: 'cells', 'sca', or 'ca'.

- method:

  \[0\] for Moore and Burch (1986) or \[1\] for Bertoni and Lombardi
  Neto (1985).

- crs:

  Coordinate reference systems

- m:

  Exponent of first equation

- n:

  Exponent of second equation

## Examples

``` r
if (FALSE) { # \dontrun{
library(terra)
library(slope)
dem <- terra:rast(system.file("ex/elev.tif", package = "terra"))
ls <- slope::ls_factor(dem, 'sca')
plot(ls)
} # }
```
