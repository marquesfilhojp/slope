#'Mininum Mappable Area
#'
#'Calculates minimum mappable area.
#'
#'@param scale Numeric. Cartographic scale
#'@param res Numeric. Resolution of DEM.
#'
#'@examples
#' library(terra)
#' library(slope)
#' dem <- terra::rast(system.file("ex/elev.tif", package = "terra"))
#' print(dem)
#' mma <- slope::minimum_mappable_area(100000, 30)
#'@export
mininum_mappable_area <- function(scale, res){
  ds <- (scale * 0.002)**2
  mmu <- ds/(res^2)
  if(mmu >= 9 && mmu < 16){
    print('Window Size 3x3')
  }
  else if(mmu >= 16 && mmu < 25 ){
    print('Window Size 4x4')
  }
  else if(mmu >= 25 && mmu < 36){
    print('Window Size 5x5')
  }
  else if(mmu >= 36 && mmu < 49){
    print('Window Size 6x6')
  }
  else if(mmu >= 49 && mmu < 64){
    print('Window Size 7x7')
  }
  else if(mmu >= 64 && mmu < 81){
    print('Window Size 8x8')
  }
  else if(mmu >= 81){
    print('Window Size 9x9')
  }
  else{
    print('Window size too large and can impact your DEM')
  }
  return(mmu)
}
