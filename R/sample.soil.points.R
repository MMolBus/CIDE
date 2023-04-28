sample.soil.points <-
  function(pic.path,
           samp.width = 0.01,
           pic.format,
           roi.area,
           sample.points) {
    chartf <- function(pic.path,
                       samp.width,
                       pic.format,
                       roi.area,
                       sample.points) {
      if (require(jpeg) == F) {
        install.packages("jpeg")

        library(jpeg)
      }

      if (require(raster) == F) {
        install.packages("raster")

        library(raster)
      }

      if (pic.format == "jpg") {
        file <- pic.path
        # list.files(path = pic.path ,
        #            pattern = ".jpg$|.JPG$|.jpeg$",
        #            full.names = T)[1]

        pic <- jpeg::readJPEG(file)

      }

      if (pic.format == "tif") {
        file <- pic.path
        # file <- list.files(path = pic.path,
        #                    pattern = ".tif$",
        #                    full.names = T)[1]
        pic <- tiff::readTIFF(file)
      }

      pic.1 <- raster::raster(pic[, , 1])
      pic.2 <- raster::raster(pic[, , 2])
      pic.3 <- raster::raster(pic[, , 3])

      pic.raster <- raster::stack(pic.1,
                                  pic.2,
                                  pic.3)
      obs.raster <-
        crop_mask(ras = all.bands, msk = obs.area)
      extent(obs.raster) <- extent(c(0, 1, 0, 1))

      options(warn = -1)

      op <-
        par(
          mfrow = c(1, 1),
          mar = c(0, 0, 0, 0),
          oma = c(0, 0, 0, 0)
        )

      on.exit(par(op))

      X11()
      raster::plotRGB(obs.raster,
                      scale = 1,
                      asp = nrow(pic.1) / ncol(pic.1))

      options(warn = 0)

      # chart.coords <- data.frame(x = numeric(), y = numeric())

      message("select soil points")

      # for (i in 1:24) {
      #   options(warn = -1)
      #   chart.coords[i, 1:2] <- click(xy = T)[1:2]
      #   options(warn = 0)
      # }
      chart.coords <- locator(n = sample.points, type = "p")
      chart.coords <- cbind(chart.coords[[1]], chart.coords[[2]])
      colnames(chart.coords) <- c("x", "y")

      sp.chart <- sp::SpatialPoints(chart.coords)

      chart_buff <-
        rgeos::gBuffer(sp.chart, width = samp.width, byid = T)

      # plot(chart_buff, add = T, col = "green")

      return(chart_buff)
    }

    sample_soil_points <- chartf(
      pic.path = pic.path,
      samp.width = samp.width,
      pic.format = pic.format,
      roi.area,
      sample.points
    )

    plot(sample_soil_points, add = T, col = "green")

    return(sample_soil_points)

  }


