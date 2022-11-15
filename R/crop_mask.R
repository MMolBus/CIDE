# Crop a raster using a binary mask
# ras = raster object to be croped
# msk = raster object with binary values, 0 and 1. Pixels = 1 will be croped in ras 
# object 
# na.mask.value = mask value to be read as in the croped raster
# Attention: ras and msk rasters have the same dimensions. 

# ras = all.bands
# msk = obs.area


crop_mask <-
  function(ras, msk, na.mask.value = 0) {
    ras2 <- ras
    for (i in 1:nlayers(ras)) {
      values(ras[[i]])[values(msk) == na.mask.value] <- NA
      ras2[[i]] <- values(ras[[i]])
    }
    values(msk)[values(msk) == na.mask.value] <- NA
    ras2[[nlayers(ras)+1]] <- msk
    
    
    ras3 <- trim(ras2)
  
  return(ras3)
  }

# rasterToPolygons(x, fun=NULL, n=4, na.rm=TRUE, digits=12, dissolve=FALSE)

