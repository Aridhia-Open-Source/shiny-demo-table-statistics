package_install <- function(x, ...) {
  for (i in x) {
    # Check if package is installed
    if (!require(i, character.only = TRUE)){
      # If the package could not be loaded then install it
      install.packages(i)
    }
  }
}

# Source this script to install all the libraries needed for the app

packages <- c("shiny", "ggvis", "shinyBS","DT")

package_install(packages)