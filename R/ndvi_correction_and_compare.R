# r <- list_raster_results[[1]]
# array(r)
# writeTIFF(array(r), "r.tif")
# writeTIFF(r, "r.tif")
#
# terra::writeRaster(r, "r1.tif", filetype = "GTiff", overwrite = TRUE)
# terra::writeRaster(r+0.75, "r2.tif", filetype = "GTiff", overwrite = TRUE)
#
# writeRaster(list_raster_results[[1]])
#
# list_raster_results[[1]] <- list_raster_results[[1]] + 0.75
# threshold.vector <- 0.48
# list_threshold_results <-
#   calculate.raster.thresh.fun(
#     list.raster.results = list_raster_results,
#     calculate.thresh    = calculate.thresh,
#     threshold.method    = threshold.method,
#     threshold.vector    = threshold.vector
#   )
#
# plot(list_threshold_results[[1]][[1]])
#
# # leer tifs juanmi
#
#
# jmrc_wd <- getpath()
# setwd(jmrc_wd)
#        # GET FILE NAMES
# nir_jmrc_file <- "NIR_calib.tif"
# ora_jmrc_file <- "Orange_calib.tif"
# list_jmrc_files <- list(ora_jmrc_file, nir_jmrc_file)
# # READ TIF FILES AND TRANSFORM TO RASTER
# i <- 1
# jmrc_raster_list <-
#   lapply(1:2, function(i)
# raster(
# readTIFF(list_jmrc_files[[i]])))
# # add cyan band as dummy band value = 0
# dummy_band <- raster(matrix(ncol = 4000, nrow = 3000, data = 0))
#
# jmrc_raster_bands <-
#   stack(jmrc_raster_list[[1]],
#        dummy_band,
#        jmrc_raster_list[[2]])
# plot(jmrc_raster_bands)
#
# # Read roi mask
# roi_mask <-
# raster(
# readTIFF("rev_2021_0101_000814_004.tif")[,,1])
# plot(roi_mask)
#
# obs_raster_jmrc <-
#   crop_mask(ras = jmrc_raster_bands, msk = obs.area)
# plot(obs_raster_jmrc)
#
# NDVI_jmrc <-
#   (obs_raster_jmrc[[3]] - obs_raster_jmrc[[1]]) /
#   (obs_raster_jmrc[[3]] + obs_raster_jmrc[[1]])
# extent(NDVI_jmrc) <-  extent(c(0, 1, 0, 1))
# plot(NDVI_jmrc)
#
# # get my NDVI
#
# NDVI_manu <-
# list_raster_results[[1]]
# plot(NDVI_manu)
#
#
# hist()
# hist(NDVI_manu)
# unique(values(NDVI_manu))
# hist(NDVI_jmrc)
# unique(values(NDVI_jmrc))
#
# terra::writeRaster(NDVI_manu, "NDVI_manu_R.tif", filetype = "GTiff", overwrite = TRUE)
# terra::writeRaster(NDVI_jmrc, "NDVI_jmrc_ArcGIS.tif", filetype = "GTiff", overwrite = TRUE)
# library(png)
# writePNG(array(NDVI_manu[[1]]),"NDVI_manu_R.png")
#
# png(file="NDVI_manu_R.png",
#     width=1000, height=1000)
# plot(NDVI_manu)
# dev.off()
# png(file="NDVI_jmrc_ArcGIS.png",
#     width=1000, height=1000)
# plot(NDVI_jmrc)
# dev.off()
#
# my_data <- data.frame("manu" = values(NDVI_manu), "jmrc" = values(NDVI_jmrc))
# sample <- sample(1:nrow(my_data), size = 1000)
# library(ggplot2)
# library("ggpubr")
# ggscatter(my_data[sample,], x = "manu", y = "jmrc",
#           add = "reg.line", conf.int = TRUE,
#           cor.coef = TRUE, cor.method = "pearson",
#           xlab = "NDVI manu", ylab = "NDVI jmrc")
#
# # Corrección NDVI
#
# plot(NDVI_manu)
#
# pic.path
#
#
# sample_points <-
#   sample.soil.points(
#     pic.path = list.files(pic_wd)[1],
#     samp.width = 0.005,
#     pic.format = "jpg",
#     roi.area = msk_list[[1]],
#     sample.points = 25
#   )
# plot(NDVI_manu)
# plot(sample_points, add=T)
#
# soil_values <- numeric()
# i <- 1
# for (i in seq_along(sample_points)) {
#   poly <- sample_points[i]
#   df_samp <- data.frame(extract(NDVI_manu,
#                                 poly))
#   options(warn = 0)
#   # if (nrow(df_samp) >= 50) {
#   #     df_samp <- df_samp[sample(x = 1:nrow(df_samp), size = 50,
#   #                               replace = F), ]
#   soil_values <- rbind(soil_values, df_samp[1, ])
#   rm(df_samp, poly)
# }
#   df_samp <- data.frame(extract(NDVI_manu,
#                                 sample_points))
# soil_values
# summary(soil_values)
# str(sample_points)
#
# hist(NDVI_manu+0.4)
# hist(soil_values)
# terra::writeRaster(NDVI_manu+0.4, "NDVI_manu_R_corregido.tif", filetype = "GTiff", overwrite = TRUE)
