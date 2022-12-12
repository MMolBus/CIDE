# cell extraction and color calibration function
# obs.area <- obs_area
# all.bands <- all_bands
# chart
# manual.mask.test
# pdf

cell.extract.color.cal.fun <-
  function(obs.area, all.bands, chart, manual.mask.test, pdf){

        # obs_ext <-
        #       extent(obs.area)
        #

# create temporal raster matrix with NA values
        temp_mat <-
              raster(matrix(data = NA,
                            nrow = nrow(all.bands),
                            ncol = ncol(all.bands),
                            byrow = T))

 #crop original raster with region of interest (roi) mask
        obs_raster <-
          crop_mask(ras = all.bands, msk = obs.area)

 # extract obs area extent
        obs_ext <-
              extent(obs_raster)


 # extract bands values as data frame
        # bands_df <-
        #       data.frame(extract(all.bands,
        #                          obs.area))
        bands_df <-
              data.frame(extract(obs_raster,
                                 obs_ext))
# Use RGBN
        # if(manual.mask.test==T){
        #       colnames(bands_df) <-
        #             c("vis.red",
        #               "vis.green",
        #               "vis.blue",
        #               "nir.blue",
        #               "mask")
        #       }else{
        #             colnames(bands_df) <-
        #                   c("vis.red",
        #                     "vis.green",
        #                     "vis.blue",
        #                     "nir.blue")
        #             }
 # Use OCN
        if(manual.mask.test==T){
              colnames(bands_df) <-
                    c("vis.orange",
                      "vis.cyan",
                      "nir.blue",
                      "mask")
              }else{
                    colnames(bands_df) <-
                          c("vis.orange",
                            "vis.cyan",
                            "nir.blue")
                    }

  # red_band <-
  #   crop(all.bands[[1]], extent(obs_ext))
  red_band <-
    obs_raster[[1]]

  extent(red_band) <-
    extent(c(0, 1, 0, 1))
  # green_band <- crop(all.bands[[2]], extent(obs_ext))
  # extent(green_band) <- extent(c(0, 1, 0, 1))
  # blue_band <- crop(all.bands[[3]], extent(obs_ext))
  # extent(blue_band) <- extent(c(0, 1, 0, 1))
  # blue_band <- crop(all.bands[[2]], extent(obs_ext))
  blue_band <-
    obs_raster[[2]]
  extent(blue_band) <- extent(c(0, 1, 0, 1))
  # if (manual.mask.test == T) {
  #   mask_band <- crop(all.bands[[5]], extent(obs_ext))
  #   extent(mask_band) <- extent(c(0, 1, 0, 1))
  #   moss_poly <- rasterToPolygons(mask_band, fun = function(x) {
  #     x == 1
  #   }, dissolve = T)
  #   raster_band <- brick(red_band, green_band, blue_band,
  #                        mask_band)
  # }else{
  #   raster_band <- brick(red_band, green_band, blue_band)
  # }
  if (manual.mask.test == T) {
    mask_band <-
      crop(all.bands[[4]], extent(obs_ext))
    extent(mask_band) <-
      extent(c(0, 1, 0, 1))
    moss_poly <-
      rasterToPolygons(mask_band, fun = function(x) {
        x == 1
    }, dissolve = T)
    raster_band <- brick(red_band, blue_band,
                         mask_band)
  }else{
    raster_band <-
      brick(red_band, blue_band)
  }
  train_df <-
    data.frame()
  # Using RGB + RN Mapir
  # chart_vals <-
  #   data.frame(red.chart =   c(0.17, 0.63, 0.15, 0.11, 0.31, 0.20,
  #                              0.63, 0.12, 0.57, 0.21, 0.33, 0.67,
  #                              0.04, 0.10, 0.60, 0.79, 0.70, 0.07,
  #                              0.93, 0.59, 0.36, 0.18, 0.08, 0.03),
  #              green.chart = c(0.10, 0.32, 0.19, 0.14, 0.22, 0.47,
  #                              0.27, 0.11, 0.13, 0.06, 0.48, 0.40,
  #                              0.06, 0.27, 0.07, 0.62, 0.13, 0.22,
  #                              0.95, 0.62, 0.38, 0.20, 0.09, 0.03),
  #              blue.chart =  c(0.07, 0.24, 0.34, 0.06, 0.42, 0.42,
  #                              0.06, 0.36, 0.12, 0.14, 0.10, 0.06,
  #                              0.24, 0.09, 0.04, 0.08, 0.31, 0.38,
  #                              0.93, 0.62, 0.39, 0.20, 0.09, 0.02),
  #              nir.chart =   c(0.43, 0.87, 0.86, 0.18, 0.86, 0.43,
  #                              0.85, 0.54, 0.54, 0.79, 0.49, 0.66,
  #                              0.52, 0.44, 0.72, 0.82, 0.88, 0.42,
  #                              0.91, 0.51, 0.27, 0.13, 0.06, 0.02))
  #

  # Using OCN Mapir
  chart_vals <-
    data.frame(orange.chart =
                 c(
                   # 0.17, 0.63, 0.15, 0.11,  0.31,    0.20,
                   # 0.63, 0.12, 0.57, 0.21,  0.33,    0.67,
                   # 0.04, 0.10, 0.60, 0.79,  0.70,    0.07,
                   # 0.93, 0.59, 0.36, 0.18,  0.08,    0.03
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   0.87477, NA, NA, 0.19940, NA, 0.01932
                   ),
               cyan.chart =
                 c(
                   # 0.10, 0.32, 0.19, 0.14, 0.22,    0.47,
                   # 0.27, 0.11, 0.13, 0.06, 0.48,    0.40,
                   # 0.06, 0.27, 0.07, 0.62, 0.13,    0.22,
                   # 0.95, 0.62, 0.38, 0.20, 0.09,    0.03
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   0.83818, NA, NA, 0.18912, NA, 0.01973
                   ),
               nir.chart =
                 c(
                   # 0.07, 0.24, 0.34, 0.06, 0.42,    0.42,
                   # 0.06, 0.36, 0.12, 0.14, 0.10,    0.06,
                   # 0.24, 0.09, 0.04, 0.08, 0.31,    0.38,
                   # 0.93, 0.62, 0.39, 0.20, 0.09,    0.02
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   NA,      NA, NA, NA,      NA, NA,
                   0.86993, NA, NA, 0.22988, NA, 0.02321
                   )
               )
# extract chart values put it with expected values
# XRITE chart use 24 tiles
  #   for (i in c(1:24)) {
  #   poly <- chart[i]
  #   options(warn = -1)
  #   df_samp <- data.frame(chart_vals[i, ], extract(all.bands,
  #                                                  poly))
  #   options(warn = 0)
  #   if (nrow(df_samp) >= 50) {
  #     df_samp <- df_samp[sample(x = 1:nrow(df_samp), size = 50,
  #                               replace = F), ]
  #   }
  #   train_df <- rbind(train_df, df_samp)
  # }
# Mapir chart we only use three positions c(19,22,24) of xrite chart
  for (i in c(1:24)) {
    poly <- chart[i]
    options(warn = -1)
    df_samp <- data.frame(chart_vals[i, ], extract(all.bands,
                                                   poly))
    options(warn = 0)
    if (nrow(df_samp) >= 50) {
      df_samp <- df_samp[sample(x = 1:nrow(df_samp), size = 50,
                                replace = F), ]
    }
    train_df <- rbind(train_df, df_samp)
  }
  # filter NA
  train_df <- train_df[!is.na(train_df$orange.chart),]

  # red_nls <- nls(red.chart ~ (a * exp(b * vis.red)), trace = F,
  #                data = train_df, start = c(a = 0.1, b = 0.1))
  # red_preds <- predict(red_nls, bands_df)
  # red_rsq <- 1 - sum((train_df$red.chart - predict(red_nls,
  #                                                  train_df))^2)/(length(train_df$red.chart) * var(train_df$red.chart))
  # red_mat <- temp_mat
  # red_mat <- crop(red_mat, extent(obs_ext))
  # extent(red_mat) <- extent(c(0, 1, 0, 1))
  # values(red_mat) <- red_preds

  # use orange chanel
  # use only three colour levels
  orange_nls <- nls(orange.chart ~ (a * exp(b * vis.orange)), trace = F,
                 data = train_df , start = c(a = 0.1, b = 0.1))
  orange_preds <- predict(orange_nls, bands_df)
  orange_rsq <- 1 - sum((train_df$orange.chart - predict(orange_nls,
                                                   train_df))^2)/(length(train_df$orange.chart) * var(train_df$orange.chart))
  orange_mat <- temp_mat
  orange_mat <- crop(orange_mat, extent(obs_ext))
  extent(orange_mat) <- extent(c(0, 1, 0, 1))
  values(orange_mat) <- orange_preds
  # green_nls <- nls(green.chart ~ (a * exp(b * vis.green)),
  #                  trace = F, data = train_df, start = c(a = 0.1, b = 0.1))
  # green_preds <- predict(green_nls, bands_df)
  # green_rsq <- 1 - sum((train_df$green.chart - predict(green_nls,
  #                                                      train_df))^2)/(length(train_df$green.chart) * var(train_df$green.chart))
  # green_mat <- temp_mat
  # green_mat <- crop(green_mat, extent(obs_ext))
  # extent(green_mat) <- extent(c(0, 1, 0, 1))
  # values(green_mat) <- green_preds
  # blue_nls <- nls(blue.chart ~ (a * exp(b * vis.blue)), trace = F,
  #                 data = train_df, start = c(a = 0.1, b = 0.1))
  # blue_preds <- predict(blue_nls, bands_df)
  # blue_rsq <- 1 - sum((train_df$blue.chart - predict(blue_nls,
  #                                                    train_df))^2)/(length(train_df$blue.chart) * var(train_df$blue.chart))
  # blue_mat <- temp_mat
  # blue_mat <-crop(blue_mat, extent(obs_ext))
  # extent(blue_mat) <- extent(c(0, 1, 0, 1))
  # values(blue_mat) <- blue_preds
  # use cyan chanel
  # use only three colour levels
  cyan_nls <- nls(cyan.chart ~ (a * exp(b * vis.cyan)), trace = F,
                  data = train_df, start = c(a = 0.1, b = 0.1))
  cyan_preds <- predict(cyan_nls, bands_df)
  cyan_rsq <- 1 - sum((train_df$cyan.chart - predict(cyan_nls,
                                                     train_df))^2)/(length(train_df$cyan.chart) * var(train_df$cyan.chart))
  cyan_mat <- temp_mat
  cyan_mat <-crop(cyan_mat, extent(obs_ext))
  extent(cyan_mat) <- extent(c(0, 1, 0, 1))
  values(cyan_mat) <- cyan_preds

  # use nir chanel
  # use only three colour levels

  nir_nls <- nls(nir.chart ~ (a * exp(b * nir.blue)), trace = F,
                 data = train_df, start = c(a = 0.1, b = 0.1))
  nir_preds <- predict(nir_nls, bands_df)
  nir_rsq <- 1 - sum((train_df$nir.chart - predict(nir_nls,
                                                   train_df))^2)/(length(train_df$nir.chart) * var(train_df$nir.chart))
  nir_mat <- temp_mat
  nir_mat <- crop(nir_mat, extent(obs_ext))
  nir_band <-
    obs_raster[[3]]
  extent(nir_mat) <- extent(c(0, 1, 0, 1))
  values(nir_mat) <- nir_preds
  # raster_mat <- brick(red_mat, green_mat, blue_mat, nir_mat)
  # raster_mat <- brick(red_mat, blue_mat, nir_mat)
  raster_mat <- brick(orange_mat, cyan_mat, nir_mat)
  # if (manual.mask.test == T) {
  #   out <- list(raster_mat, raster_band, red_rsq, green_rsq,
  #               blue_rsq, nir_rsq, moss_poly)
  #   names(out) <- c("raster_mat", "raster_band",
  #                   "red_rsq", "green_rsq", "blue_rsq",
  #                   "nir_rsq", "moss_poly")
  # }else {
  #   out <- list(raster_mat, raster_band, red_rsq, green_rsq,
  #               blue_rsq, nir_rsq)
  #   names(out) <- c("raster_mat", "raster_band",
  #                   "red_rsq", "green_rsq", "blue_rsq",
  #                   "nir_rsq")
  # }
  # if (manual.mask.test == T) {
  #   out <- list(raster_mat, raster_band, red_rsq,
  #               blue_rsq, nir_rsq, moss_poly)
  #   names(out) <- c("raster_mat", "raster_band",
  #                   "red_rsq", "blue_rsq",
  #                   "nir_rsq", "moss_poly")
  # }else {
  #   out <- list(raster_mat, raster_band, red_rsq,
  #               blue_rsq, nir_rsq)
  #   names(out) <- c("raster_mat", "raster_band",
  #                   "red_rsq", "blue_rsq",
  #                   "nir_rsq")
  # }
  if (manual.mask.test == T) {
    out <- list(raster_mat, raster_band, orange_rsq,
                cyan_rsq, nir_rsq, moss_poly)
    names(out) <- c("raster_mat", "raster_band",
                    "orange_rsq", "cyan_rsq",
                    "nir_rsq", "moss_poly")
  }else {
    out <- list(raster_mat, raster_band, orange_rsq,
                cyan_rsq, nir_rsq)
    names(out) <- c("raster_mat", "raster_band",
                    "orange_rsq", "cyan_rsq",
                    "nir_rsq")
  }
  return(out)}

