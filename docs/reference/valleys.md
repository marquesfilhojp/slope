# Valleys

Detects different types of valleys, based on Silveira and Silveira
(2020). The primary difference is the use of a rectangular local
neighborhood shape instead of a circular one, in the calculation of
Black Top Hat (BTH) (Rodriguez et al., 2002). For more satisfactory
results, it is recommended to define the moving window based on the
minimum mappable area and the fill() function.

## Usage

``` r
valleys(x, w, type)
```

## Arguments

- x:

  Input DEM raster

- w:

  Number of cells for the window size

- type:

  Each number represents a specific landform, for example: (1)
  Flat-bottomed valleys, (2) Open valleys, and (3) Incised valleys.
