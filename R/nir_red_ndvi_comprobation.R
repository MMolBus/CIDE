# vis_jpg  <-
#   jpeg::readJPEG(paste("./JPG/", img.photo, sep = ""))

# tif_path <- getpath()
# install.packages("tiff")
# library(tiff)
# nir_TIF  <-
#   tiff::readTIFF(paste(tif_path, "\\", "NIR_calib.TIF", sep = ""))
# vis_TIF  <-
#   tiff::readTIFF(paste(tif_path, "\\", "Orange_calib.TIF", sep = ""))
#
#
#
# # vis_jpg  <-
# #   jpeg::readJPEG(paste0(getwd(),"/", img.photo))
# dim(vis_TIF)
# tif.1 <-         raster(vis_TIF)
# tif.2 <-         raster(nir_TIF)
#
# all_bands_calib <-
#   stack(tif.1, tif.2)
#
#
# obs.nir.cal <-
# crop_mask(ras = all_bands_calib, msk = obs.area)
#
# plot(obs.nir.cal)
#
# plot(
#   calibration_results[[1]]
# )
# plot(obs.nir.cal[[2]])
#
# plot(
#   calibration_results[[1]][[3]]
# )
#
# NDVI_cal <- (obs.nir.cal[[3]]-obs.nir.cal[[1]])/(obs.nir.cal[[3]]+obs.nir.cal[[1]])
# plot(NDVI_cal)
#
#
# # NDVI <- (raster.mat[[3]]+ raster.mat[[1]] - raster.mat[[1]]) /
# #   (raster.mat[[3]] + raster.mat[[1]] + raster.mat[[1]])
# plot(all_bands)
# plot(all_bands[[1]])
# plot(all_bands[[2]])
# plot(all_bands[[3]])
#
# NDVI_nocal <-
#   (all_bands[[1]] -
#      all_bands[[2]]) / (all_bands[[1]] +
#                           all_bands[[2]])
# plot(NDVI_nocal)
#
#
#
# NDVI <- list_raster_results[[1]]
# plot(NDVI)
#
#
# # NDVI <-
#
#
# # NDVI
# plot(raster_mat)
# plot(
#   (
#   raster_mat[[1]]-raster_mat[[2]]
#   )/(
#     raster_mat[[1]]+raster_mat[[2]]
#   )
#   )
#
#
#
#
#
#
#
#   plot(
#   (
#   raster_mat[[3]]+raster_mat[[1]]-raster_mat[[1]]
#   )/(
#     raster_mat[[3]]+raster_mat[[1]]+raster_mat[[1]]
#   )
#   )
#
#
# plot(NDVI.2)
#
# # tif.1 <-         raster(vis_TIF[, , 1])
# # tif.2 <-         raster(vis_TIF[, , 2])
# # tif.3 <-         raster(vis_TIF[, , 3])
# # all_bands <-
# #   stack(jpg.1, jpg.2, jpg.3)
#
#
# # nir_tiff  <-
# #   tiff::readTIFF(paste("./nir/", nir.photo, sep = ""))
# # nir_blue  <- raster(nir_tiff[, , 3]) + 10 / 256
# if(manual.mask.test==T){
#   mask_tiff  <-
#     suppressWarnings(tiff::readTIFF(paste("./mask/", mask.photo, sep = "")))
#   # transform 0 to 1 from binary tif obtained from image J
#   binar_mask   <- raster(mask_tiff)==0
# }
#
# asp <- nrow(jpg.1) / ncol(jpg.1)
# if(manual.mask.test==T){
#   all_bands <-
#     # stack(vis_red, vis_green, vis_blue, nir_blue, binar_mask)
#     stack(jpg.1, jpg.2, jpg.3)
#
#   names(all_bands) <-
#     c("vis.orange", "vis.cyan", "nir", "binar.mask")
# }else{
#   all_bands <-
#     # stack(vis_red, vis_green, vis_blue, nir_blue)
#     stack(jpg.1, jpg.2, jpg.3)
#   names(all_bands) <-
#     c("vis.orange", "vis.cyan", "nir.blue")
# }
# return(all_bands)
