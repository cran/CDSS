#' Derive a basis from a surmise function
#'
#' \code{cdss_sf2basis} expects a surmise function object 
#' and returns the corresponding basis.
#'
#' @param sf Surmise function
#'
#' @return Matrix representing the basis.
#' 
#' @export
cdss_sf2basis <- function(sf) {
  if (!(inherits(sf, "cdss_sf"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sf"),
                 dQuote("cdss_sf")))
  }
  
  skills <- dim(sf)[2]-1
  unique(apply(as.matrix(sf[, 2:(skills+1)]), 2, as.numeric))
}