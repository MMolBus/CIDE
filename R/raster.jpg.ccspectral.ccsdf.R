# Read TIF Images and set aspect ratio
# vis.photo <- vis_photo
# nir.photo <- nir_photo
# mask.photo <- mask_photo
# img.photo <-  img_photo

raster.jpg.ccspectral <- function(img.photo,
                                  # nir.photo,
                                  manual.mask.test, mask.photo){
  vis_jpg  <-
    jpeg::readJPEG(paste("./JPG/", img.photo, sep = ""))
  # vis_jpg  <-
  #   jpeg::readJPEG(paste0(getwd(),"/", img.photo))

  jpg.1 <-         raster::raster(vis_jpg[, , 1])
  jpg.2 <-         raster::raster(vis_jpg[, , 2])
  jpg.3 <-         raster::raster(vis_jpg[, , 3])
  # jpg.3 <-       raster::raster(vis_jpg[, , 3])  + 10 / 256
  # all_bands <-
  #       stack(jpg.1, jpg.2, jpg.3)


  # nir_tiff  <-
  #   tiff::readTIFF(paste("./nir/", nir.photo, sep = ""))
  # nir_blue  <- raster(nir_tiff[, , 3]) + 10 / 256
  if(manual.mask.test==T){
    mask_tiff  <-
      suppressWarnings(tiff::readTIFF(paste("./mask/", mask.photo, sep = "")))
    # transform 0 to 1 from binary tif obtained from image J
    binar_mask   <-
      raster::raster(mask_tiff)==0
  }

  asp <- nrow(jpg.1) / ncol(jpg.1)
  if(manual.mask.test==T){
    all_bands <-
      # stack(vis_red, vis_green, vis_blue, nir_blue, binar_mask)
      raster::stack(jpg.1, jpg.2, jpg.3)

    names(all_bands) <-
      c("vis.orange", "vis.cyan", "nir.blue", "binar.mask")
  }else{
    all_bands <-
      # stack(vis_red, vis_green, vis_blue, nir_blue)
      raster::stack(jpg.1, jpg.2, jpg.3)
    names(all_bands) <-
      c("vis.orange", "vis.cyan", "nir.blue")
  }
  return(all_bands)
}
