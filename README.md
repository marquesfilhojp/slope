<img src="man/figures/slope.png" align="right" width="150" />

## *slope*: An R Package Identify Slope Patterns and Processes

*slope* is R experimental package who provides different geomorphometric approaches, for example: **Nine type básics of slope forms** (Dikau, 1989), **Transformed Curvature** (Evans, 1984), **Transformed Slope** (Csillik *et al*. 2015), **Dissection Index** (Evans, 1977), **Surface Relief Ratio** (Berry, 2002), **Roughness Concentration Index** (Sampaio and Augustin, 2014), **Ridges, Tops and Valleys** (Silveira and Silveira, 2020), **Geomorphic Change Detection** (Wheaton *et al*. 2010), **Sediment Connectivity** (Cavalli *et al*. 2013), **slider** module, exclusive to the slope R package (marquesfilho, 2026) and shorthly **Topographic Position Index** (Weiss, 2001; Silveira and Silveira, 2017), **Sediment Transport Index** (Moore and Burch, 1986); **Revised Universal Soil Loss Equation** (Renard *et al*. 1997) and **Thematic Susceptibility Mapping** for Landslide and Gully Erosion (Filho *et al*. 2024). 

#### For instalation:
```R
install.packages('remotes')
library(remotes)
remotes::install_github("marquesfilhojp/slope")
library(slope)

```

For citation:

Marques Filho, J. da P. (2026). marquesfilhojp/slope: *slope*: Identify slope patterns and processes (Version v0.3.2) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.21325742

## Dependencies 

The following dependencies are required for the proper performance of the R package `slope`. 
* **classInt**: 
* **ggplot2**:
* **MultiscaleDTM**:
* **sf**:
* **spatstat**:
* **terra**:
* **whitebox**:

## ⚙️ Installation by Operating System
Currently, the R package *slope* v.0.4.5 has been developed solely for *Windows* operating systems and *Linux* distributions such as Debian, Ubuntu, and Linux—specifically **version 22.04 LTS Jammy**. Jellyfish.

### 🪟 Windows
It is recommended to use R version 4.5.x or higher and Rtools 45 or higher to install the R package `terra`, which is essential for the operation of this package.

```https
R v.4.5.x: https://cran.r-project.org/bin/windows/base/old/4.5.3/
Rtools45: https://cran.r-project.org/bin/windows/Rtools/rtools45/rtools.html 
```

### 🐧 Linux

On *Linux* distributions such as Ubuntu 22.04 LTS (Jammy Jellyfish) and other similar systems, it is recommended to initially install the R `terra` package to ensure the proper functioning of this package, for manipulating vector and raster data with following libraries GDAL (>= 2.2.3), GEOS (>= 3.4.0), PROJ (>= 4.9.3), netcdf (>=4.1.3), sqlite3 and tbb.


```bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libtbb-dev libnetcdf-dev
```
### References



