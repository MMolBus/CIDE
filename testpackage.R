# Make a toy package "Trypckg"
# ------------------------------------------------------------------------------
# Copy from https://r-pkgs.org/Whole-game.html
# Author: Manuel Molina-Bustamante
# Date: 20230503
# ------------------------------------------------------------------------------
# install packages--------------------------------------------------------------
install.packages(c("devtools", "roxygen2", "testthat", "knitr"))
# install devtools--------------------------------------------------------------
library(devtools)
packageVersion("devtools")
# 2.3 Toy package: trypackage----------------------------------------------------
# Call create_package() to initialize a new package in a directory on your
# computer.
create_package("D:/Users/Usuario/Documents/GitHub/Trypckg")

# introduce your functions in R folder

# Create git repository loading required package: usethis--------------------------------------------
# we make it also a Git repository, with use_git(). (By the way, use_git() works
# in any project, regardless of whether it’s an R package.)
library(usethis)
use_git()

# 2.6 Write the first function in a differnt .R file and save it in R folder--------------
# In our case we create strsplit1()

document()
help(ccspectral.df)

use_r("tif2raster")
# Note that load_all() make the strsplit1() function available, although it does
# not exist in the global environment.

load_all()
(x <- "D:/Users/Usuario/Documents/GitHub/CIDE/data/JPG")
# chart2(x, pic.format = "jpg")
library(raster)
library(sp)
chart <-
chart2(pic.path = x, pic.format = "jpg")
exists("chart2", where = globalenv(), inherits = FALSE)

check()

# ------------------------------------------------------------------------------

