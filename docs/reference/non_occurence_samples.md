# Non Occurrence Samples

Determines non-occurrence samples of susceptibility based on the Buffer
Controlling Samples (BCS) method described by Gu et al. (2024).

## Usage

``` r
non_occurence_samples(x, y, distance, n_samples, drop_cols_non, drop_cols, col)
```

## Arguments

- x:

  Input stack raster

- y:

  Input samples (vector files)

- distance:

  Area or zone of influence of the event occurrence samples.

- n_samples:

  Regarding the number of samples representing the non-occurrence of
  events, it is suggested, in order to balance the sample set, to use a
  sample size equal to the number of event occurrences.

- drop_cols_non:

  This allows you to remove information that will not be used; it is
  suggested to leave only the column referring to the non-occurrence of
  events, e.g \[0\].

- drop_cols:

  It allows for the removal of unused information; it is suggested to
  retain only the column regarding event occurrences, e.g \[1\].

- col:

  Target field of occurrence.

## Examples

``` r
if (FALSE) { # \dontrun{
library(pacman)
p_load(terra, sf, slope)
rasters <- terra::rast(system.file("ex/stack.tif", package = "terra"))
samples <- terra::vect(system.file("ex/samples.shp", package = "terra"))
non_occurrence <- slope::non_occurrence_samples(rasters, samples, 500, 1218, -c(1:14), -c(1), 'classes')
plot(non_occurrence)
} # }
```
