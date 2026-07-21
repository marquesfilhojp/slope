<img src="man/figures/slope.png" align="right" width="150" />

## slope: An R Package Identify Slope Patterns and Processes

Slope is R experimental package who provides different geomorphometric approaches, for example: Nine type básics of slope forms (Dikau, 1989), Transformed Curvature (Evans, 1984), Transformed Slope (Csillik et al. 2015), Dissection Index (Evans, 1977), Surface Relief Ratio (Berry, 2002), Roughness Concentration Index (Sampaio and Augustin, 2014), Ridges, Tops and Valleys (Silveira and Silveira, 2020), Geomorphic Change Detection (Wheaton et al. 2010), Sediment Connectivity (Cavalli et al. 2013), slider module, exclusive to the slope R package (marquesfilho, 2026) and shorthly Topographic Position Index (Weiss, 2001; Silveira and Silveira, 2017), Sediment Transport Index (Moore and Burch, 1986); Revised Universal Soil Loss Equation (Renard et al. 1997) and Thematic Susceptibility Mapping for Landslide and Gully Erosion (Filho et al. 2024). 

#### For instalation:
```R
install.packages('remotes')
library(remotes)
remotes::install_github("marquesfilhojp/slope")
library(slope)

```

For citation:

Marques Filho, J. da P. (2026). marquesfilhojp/slope: slope: Identify slope patterns and processes (Version v0.3.2) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.21325742

## Dependências 

Para o adequado desempenho do pacote R slope são necessárias às seguintes dependências. 
. classInt: 
. ggplot2:
. MultiscaleDTM:
. sf:
. spatstat:
. terra:
. whitebox:

## Instalação por Sistema Operacional

# Windows
É recomendável utilizar a versão R 4.5.x ou superiores e a ferramenta Rtools 45 ou superior, para a instalação do pacote R terra, essencial para o funcionamento do presente pacote.

# Linux

Nas distros Linux, como Ubuntu 22.04 LTS (Jammy Jellyfish) e entre outros sistemas similares, recomenda-se a instalação inicial do pacote R terra, para fomentar o funcionamento do presente pacote. 

´´´bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libtbb-dev libnetcdf-dev
´´´
