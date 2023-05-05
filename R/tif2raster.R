# Title: Import tif as raster
# Function:
# R functions
#' import tif file and set as raster
#' @param x string. Path where you can find the tif file.
#'
#' @return A raster file with three layers.
#'
#' @author Manuel Molina-Bustamante.
#' @export

tif2raster <-
  function(msk_name) {
    # set warnings off
    options(warn = -1)
    # import  tif file

    tif_file <-
      tiff::readTIFF(msk_name)


    # str(tif_file)
    # class(tif_file)

    # transform to raster file and select only the first channel, all are the same

    msk <-
      raster::raster(tif_file[, , 1])
    # values(msk)
    msk_bands <-
      msk

    options(warn = 0)

    print(paste(msk_name, "file mask imported."))
    return(msk_bands)

  }
