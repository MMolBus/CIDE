# Title: ccspectral.df
# Function:
# R functions
#' function to segmentate an image between plant and soil using autothreshold,
#' supervised autothreshold or manual criteria. Measurement of plant
#' physiological activity.
#' @param tif.path string. File path where you can find the image files.
#' @param chart SpatialPolygons. Color chart tile position defined by 24
#' features one by each color tile.
#' @param obs.areas list. List of binary rasters with the observation area
#' defined by 1 and 0 to non interest area.
#' @param pdf logical.If you want to obtain a pdf with index and segmented
#' result. Default = F
#' @param calculate.thresh logical.If you want to calculate threshold
#' atomaticaly in the observed area. Default = F
#' @param descrip logical. If you want to calculate statistical descriptors
#' over the segmented surface values. Default = F
#' @param manual.mask.test logical. If you want to conduct a quality test
#' confronting the segmentation results with ground true areas, if true  you
#' need to provide this segmentation masks. Default = F
#' @param index. character. character vector with the names of spectral indices
#' that you want to calculate. Possible values:
#' "NDVI" (Normalized Differential Vegetation Index), "SR" (Simple Ratio),
#' "MSAVI"(Second Modified Soil Adjusted Vegetation Index),
#'  "EVI"(Enhanced Vegetation Index), "CI"(Crust Index),
#'  "BSCI"(Biological Soil Crust Index), "BI"(Brightness Index),
#' "NORR"(Normalized Red), "NORG"(Normalized Green), "NORB"(Normalized Blue),
#' "EXR"(Excess Red), "EXG"(Excess Green),
#' "EXB"(Excess Blue), "EXGR"(Excess Green minus Excess Red), "CIVE"(Color Index
#'  of Vegetation Extraction), "VEG"(Vegetative),
#' "HUE"(Dominant colour wavelength level), "SAT"(Saturation), "VAL"(Value).
#' Default = c("NDVI", "SR", "MSAVI", "EVI", "CI", "BSCI", "BI", "NORR", "NORG",
#'  "NORB", "EXR", "EXG", "EXB", "EXGR", "CIVE", "VEG", "HUE", "SAT", "VAL")
#' @param threshold.method character. if _calculate.thresh_ = T define the
#' autothershold method to apply over the calculated spectral index raster.
#' It coulb be one of this values: "Huang", "IsoData", "IJDefault", "Li",
#' "Mean", "MinErrorI", "Moments", "Otsu", "Percentile",
#' "RenyiEntropy", "Shanbhag", "Triangle". This function is based on
#' _autothresholdr_ R package (Landini et al., 2017).
#' Otherwise, an adaptation to R of Auto Threshold plugin from ImageJ.
#' (https://imagej.net/Auto_Threshold).
#' Default = NULL
#' @param threshold.vector numeric. if _calculate.thresh_ = F define the
#' thershold values for defined _index._ values.
#' Values must be provided in the same order as "index." values.
#' Default = NULL
#' @param descriptors. character. If descrip = T you provide a vector with the
#' descriptors to be calculated in over the segmented areas. Values could be.
#' "median","mean","sd","min","max" and "diff.range"(range amplitude).
#' @return A Data frame with the calculated values for the each image in the
#' tif.path
#' @author Manuel Molina-Bustamante
#' @export

ccspectral.df <- function(tif.path,
                          chart,
                          obs.areas,
                          pdf = F,
                          calculate.thresh = F,
                          descrip = F,
                          manual.mask.test=F,
                          index. = c("NDVI"),
                          threshold.method = NULL,
                          threshold.vector = NULL,
                          descriptors. =
                            c("median","mean","sd","min",
                              "max","diff.range")
                          )
{

# Charge library ----------------------------------------------------------
# Subsection 1: Preparing data -----------------------------------------------------------------------------------------
  # Check workspace MANDATORY sub-directories =============================================================
    # if(manual.mask.test==T){
    #   if(any(list.files(getwd()) %in% "nir") &
    #    any(list.files(getwd()) %in% "vis") &
    #    any(list.files(getwd()) %in% "mask")) {
    # }else{
    #   wd <- getwd()
    #   setwd(tif.path)
    #   on.exit(setwd(wd))
    # }
    #   }else{
      if(any(list.files(getwd()) %in% "JPG") &
         any(list.files(getwd()) %in% "rois")) {
      }else{
        wd <- getwd()
        setwd(tif.path)
        on.exit(setwd(wd))}
  # }

    # Order custom arguments values and test required arguments =============================================

    if(calculate.thresh==T){
      surface. = c("predict.moss", "predict.backgr")
      if(any(threshold.method==c("Huang", "IJDefault",
                                 "IsoData", "Li",
                                 "Mean", "MinErrorI",
                                 "Moments", "Otsu",
                                 "Percentile", "RenyiEntropy",
                                 "Shanbhag", "Triangle"))==F){
      stop("if you want to calculate auto threshold value
             you need to define a valid threshold.method argument.")}
    }else{
      if(exists("threshold.vector")==F){
        stop("if you don't want to calculate autothreshold values you
        need to define a threshold.vector values for the selected index.")
      }else{
        if(length(index.)!=length(threshold.vector)){
          stop("thershold.vector must have the same length as the
              index. argument")}
        threshold.method <- "manual"

      }
      surface. = c("predict.moss", "predict.backgr")
      }

    if(manual.mask.test==T){
     surface. <- c(surface.,"baseline.moss", "baseline.backgr", "True.Negative","False.Positive", "False.Negative",
                    "True.Positive")
      }

    surface_order <- c("predict.moss",   "predict.backgr", "baseline.moss", "baseline.backgr")
    surface. <- surface.[order(match(surface., surface_order))]

    index_order <- c("NDVI", "SR", "MSAVI", "EVI", "CI", "BSCI", "BI",
                     "NORR", "NORG", "NORB", "EXR", "EXG", "EXB", "EXGR",
                     "CIVE", "VEG", "HUE", "SAT", "VAL")
    index. <- index.[order(match(index., index_order))]

    descriptors_order <- c("median", "mean", "sd", "min",
                           "max", "diff.range"
                           # "threshold",
                           # "n.cell"
                           )
    descriptors. <- descriptors.[order(match(descriptors., descriptors_order))]

    # Create exportation folder =============================================================================

    out_dir <- paste0("output ",Sys.time(), " ", threshold.method)
    out_dir <- gsub(":", ".", out_dir)
    dir.create(out_dir)
    # Prepare dataframe for exportation results and write empty csv =============================================

  # Create empty data.frame -----------------------------
    if(descrip==F){
      if(calculate.thresh==T){#if you want to calculate autothresholds
        if(manual.mask.test==F){
          if(length(index.)>1){
            df_names <-
              # c("sample", "vis.file", "nir.file",
              c("sample", "img.file",
                do.call(c,
                        lapply(1:length(index.), function(i)
                          c(apply(expand.grid(surface.,
                                              index.[i]), 1, paste, collapse=".")
                            )
                          )
                        ),
                apply(expand.grid("threshold.value",
                                  index.), 1, paste, collapse="."),
                "threshold.method")
          }else{
            df_names <-
              # c("sample", "vis.file", "nir.file",
              c("sample", "img.file",
              unlist(
                  lapply(1:length(index.), function(i)
                    c(apply(expand.grid(surface.,
                                        index.[i]), 1, paste, collapse=".")
                      )
                    )
                  ),
                apply(expand.grid("threshold.value",
                                  index.), 1, paste, collapse="."),
                "threshold.method")

          }
          }else{
            if(length(index.)>1){
              df_names <-
                # c("sample", "vis.file", "nir.file",
                c("sample", "img.file",
                  do.call(c,
                          lapply(1:length(index.), function(i)
                            c(apply(expand.grid(
                              surface.,
                              index.[i]), 1, paste, collapse = ".")
                              )
                            )
                          ),
                  apply(expand.grid("threshold.value",
                            index.), 1, paste, collapse="."),
                  "threshold.method")
              }else{
                df_names <-
                  # c("sample", "vis.file", "nir.file",
                  c("sample", "img.file",
                    unlist(lapply(1:length(index.), function(i)
                      c(apply(expand.grid(
                        surface.,
                        index.[i]), 1, paste, collapse = ".")
                        )
                      )
                      ),
                    apply(expand.grid("threshold.value",
                            index.), 1, paste, collapse="."),
                    "threshold.method")
              }
            }
            }else{#if you don't want to calculate autothresholds, use a threshold vector value,
              if(manual.mask.test==F){
                if(length(index.)>1){
                  df_names <-
                    # c("sample", "vis.file", "nir.file",
                    c("sample", "img.file",
                      do.call(c,
                              lapply(1:length(index.), function(i)
                                c(apply(expand.grid(
                                  surface.,
                                  index.[i]), 1, paste, collapse=".")
                                  )
                                )
                              ),
                      apply(expand.grid("threshold.value",
                                        index.), 1, paste, collapse="."),
                      "threshold.method")
                  }else{
                    df_names <-
                      # c("sample", "vis.file", "nir.file",
                        c("sample", "img.file",
                        unlist(lapply(1:length(index.), function(i)
                          c(apply(expand.grid(
                            surface.,
                            index.[i]), 1, paste, collapse = ".")
                            )
                          )
                          ),
                        apply(expand.grid("threshold.value",
                                          index.), 1, paste, collapse="."),
                        "threshold.method")
                    }
                }else{
                  if(length(index.)>1){
                    df_names <-
                      # c("sample", "vis.file", "nir.file",
                      c("sample", "img.file",
                        do.call(c,
                                lapply(1:length(index.), function(i)
                                  c(apply(expand.grid(
                                    surface.,
                                    index.[i]), 1, paste, collapse = ".")
                                    )
                                  )
                                ),
                        apply(expand.grid("threshold.value",
                                          index.), 1, paste, collapse="."),
                        "threshold.method")
                    }else{
                      df_names <-
                        # c("sample", "vis.file", "nir.file",
                        c("sample", "img.file",
                          unlist(lapply(1:length(index.), function(i)
                            c(apply(expand.grid(
                              surface.,
                              index.[i]), 1, paste, collapse = ".")
                              )
                            )
                            ),
                          apply(expand.grid("threshold.value",
                                            index.), 1, paste, collapse="."),
                          "threshold.method")
                    }
                }
              }
        }else{
          if(calculate.thresh==T){#if you want to calculate autothresholds
            if(manual.mask.test==F){
                df_names <-
                  # c("sample", "vis.file", "nir.file",
                  c("sample", "img.file",
                    unlist(
                      unlist(
                                    lapply(1:length(index.), function(i)
                                      lapply(1:length(surface.), function(j)
                                        c(apply(expand.grid(surface.[j],
                                                            index.[i]), 1, paste, collapse="."),
                                          apply(expand.grid(surface.[j],
                                                            descriptors.,
                                                            index.[i]), 1, paste, collapse=".")
                                          )
                                        )
                                      )
                                    )
                            ),
                    apply(expand.grid("threshold.value",
                                      index.), 1, paste, collapse="."),
                    "threshold.method")

              }else{
                df_names <-
                  # c("sample", "vis.file", "nir.file",
                  c("sample", "img.file",
                    unlist(
                      unlist(
                                    lapply(1:length(index.), function(i)
                                      lapply(1:length(surface.), function(j)
                                        c(apply(expand.grid(surface.[j],
                                                            index.[i]), 1, paste, collapse="."),
                                          apply(expand.grid(surface.[j],
                                                            descriptors.,
                                                            index.[i]), 1, paste, collapse=".")
                                          )
                                        )
                                      )
                                    )
                            ),
                    apply(expand.grid("threshold.value",
                                      index.), 1, paste, collapse="."),
                    "threshold.method")}
            }else{#if you don't want to calculate autothresholds, use a threshold vector value,
              if(manual.mask.test==F){
                df_names <-
                  # c("sample", "vis.file", "nir.file",
                  c("sample", "img.file",
                   unlist(
                            unlist(
                                    lapply(1:length(index.), function(i)
                                      lapply(1:length(surface.), function(j)
                                        c(apply(expand.grid(surface.[j],
                                                            index.[i]), 1, paste, collapse="."),
                                          apply(expand.grid(surface.[j],
                                                            descriptors.,
                                                            index.[i]), 1, paste, collapse=".")
                                          )
                                        )
                                      )
                                    )
                            ),
                    apply(expand.grid("threshold.value",
                                      index.), 1, paste, collapse="."),
                    "threshold.method")
                }else{
                  df_names <-
                    # c("sample", "vis.file", "nir.file", "real.moss.cover",
                    c("sample", "img.file", "real.moss.cover",
                      unlist(
                        unlist(
                                      lapply(1:length(index.), function(i)
                                        lapply(1:length(surface.), function(j)
                                          c(apply(expand.grid(surface.[j],
                                                              index.[i]), 1, paste, collapse="."),
                                            apply(expand.grid(surface.[j],
                                                              descriptors.,
                                                              index.[i]), 1, paste, collapse=".")
                                            )
                                          )
                                        )
                                      )
                              ),
                      apply(expand.grid("threshold.value",
                                        index.), 1, paste, collapse="."),
                      "threshold.method")}
            }
        }

      df <- data.frame(matrix(ncol = length(df_names), nrow = 0))
      colnames(df) <- df_names

      # set df col class
      col_class <-
        c(rep("character", 3), rep("numeric", length(df_names) - 4),"character")
      for (i in c(1:length(col_class))) {
        class(df[, i]) <- col_class[i]
      }

    rm(col_class)

    # Create results csv-----------------------------------------------------
    if(calculate.thresh == TRUE){
    summary_file <- paste0(out_dir,  paste0("/",threshold.method,"_","summary_data.csv"))
    if(!file.exists(summary_file)){write.csv(df, summary_file, row.names = F)}
    } else{
      summary_file <- paste0(out_dir,  paste0("/summary_data.csv"))
      if(!file.exists(summary_file)){write.csv(df, summary_file, row.names = F)}
      }



  # Import images as list ---------------------------------------------------

    # vis_files <- list.files(path = "./vis")
    img_files <- list.files(path = "./JPG")
    # nir_files <- list.files(path = "./nir")
    if(manual.mask.test==T){
      mask_files <- list.files(path = "./mask", pattern = ".tif$")}


  # Check if a matching error exists between lists --------------------------
    # if (length(vis_files) != length(nir_files)) {
    #   stop("Different number of VIS and NIR photos")
    # }
    # Samples per picture
    # indetermined obs areas for picture
    total_samples <- length(obs.areas)

    # Set sample names #############################################################################
    # extract cell names
    # cell_names <-
    #       gsub(".*/", "",
    #            list.files(path = "./rois",pattern=".roi$",full.names = F, recursive = T))
    cell_names <-
          gsub(".*/", "",
               list.files(path = "./rois",pattern=".tif$",full.names = F, recursive = T))

   # we have the .roi files in picture named folders in the "rois" directory
    samples.per.pic <-
      unlist(
        lapply(1:(length(list.dirs("rois"))-1),
                     function(i) length(list.files(list.dirs("rois")[i+1]))))
    all_named       <-
      data.frame(photo = unlist(lapply(1:length(img_files),
                                        function(i) rep(img_files[i], each=samples.per.pic[i]))),
                 cell = cell_names)
        if (file.exists("names.csv")) {
      sample_names <- c(as.character(read.csv("names.csv")[, 1]))
      if (length(sample_names) != total_samples) {
        stop("File of sample names contains less/more names than samples")
      }
      all_named$sample <- sample_names
    } else{
      all_named$sample <- c(names = paste0("obs_", 1:(total_samples)))
    }
    print(all_named)

  # Subsection 2: set functions ------------------------------------------------------------------------------------------
    # Calcs function =========================================================================================

    # source("./ccspectral/calcs.autothreshold.R")

  # Subsection 3: make calculations  ----------------------------------------

    all <-
      data.frame(Var1 = 1:length(all_named[,1]), Var2 = 1:length(obs.areas)) %>%
      dplyr::arrange(Var1)


    print(all)

    start_time <- Sys.time()
    message(paste("Starting calculations at", start_time))
  apply(all, 1, function(pair) {
    calcs(
      pair[1],
      pair[1],
      obs.areas = obs.areas,
      img.files = all_named[,1],
      # nir.files = all_named[,1],
      chart=chart,
      mask.files = mask_files,
      manual.mask.test = manual.mask.test,
      summary.file = summary_file,
      total.samples = total_samples,
      index.= index.,
      descriptors.= descriptors.,
      calculate.thresh = calculate.thresh,
      descrip = descrip,
      threshold.method = threshold.method,
      threshold.vector = threshold.vector,
      pdf = pdf,
      start.time=start_time
      )
  })
  message("Processed files may be found at: ", paste0(tif.path, out_dir))
}

