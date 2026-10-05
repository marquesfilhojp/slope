# Land Surface Parameters

``` r

library(pacman)
p_load(slope, terra)
dem <- terra::rast("dem/elev.tif")
di <- slope::dissection_index(dem, 7)
plot(di)
```

![](lsp_files/figure-html/setup-1.png)
