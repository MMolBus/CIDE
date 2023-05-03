# Make CIDE package
# ------------------------------------------------------------------------------
# Copy from https://r-pkgs.org/Whole-game.html
# Author: Manuel Molina-Bustamante
# Date: 20230503
# ------------------------------------------------------------------------------
# install packages--------------------------------------------------------------

install.packages("librarian")
library(librarian)
librarian::shelf("devtools", "roxygen2", "testthat", "knitr")
# install devtools--------------------------------------------------------------
library(devtools)
packageVersion("devtools")
# 2.3 Toy package: trypackage---------------------------------------------------
# Call create_package() to initialize a new package in a directory on your
# computer.
create_package("D:/Users/Usuario/Documents/GitHub/Trypckg")

# introduce your functions in R folder

# Create git repository loading required package: usethis-----------------------
# we make it also a Git repository, with use_git(). (By the way, use_git() works
# in any project, regardless of whether it’s an R package.)
install.packages("usethis")
library(usethis)
use_git()

# 2.6 Write the first function in a differnt .R file and save it in R folder----
# In our case we create strsplit1()

# put the definition of strsplit1()---------------------------------------------
# and save it
use_r("strsplit1")


# test drive function strsplit1-----------------------------------------------------------
# If this were a regular R script, we might use RStudio to send the function
# definition to the R Console and define strsplit1() in the global environment.
# Or maybe we’d call source("R/strsplit1.R"). For package development, however,
# devtools offers a more robust approach.
# Call load_all() to make strsplit1() available for experimentation.
devtools::load_all()

# Now call strsplit1(x) to see how it works.

(x <- "alfa,bravo,charlie,delta")
#> [1] "alfa,bravo,charlie,delta"
strsplit1(x, split = ",")
#> [1] "alfa"    "bravo"   "charlie" "delta"

# Note that load_all() has made the strsplit1() function available, although it
# does not exist in the global environment.
exists("strsplit1", where = globalenv(), inherits = FALSE)
#> [1] FALSE
help(ccspectral.df)

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

