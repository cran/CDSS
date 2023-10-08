#' Reduce a surmise function with respect to item equivalence
#'
#' \code{reduce_sf} takes a surmise function and returns its
#' reduction to non-equivalent items.
#'
#' @param sf Surmise function
#' @return Surmise function reduced by equivalences
#'
#' @family Utility functions
#'
#' @export
reduce_sf <- function(sf) {
  if (!inherits(sf, "cdss_sf")) {
    stop(sprintf("%s must be of class %s.", dQuote("sf"), dQuote("cdss_sf")))
  }

  sf <- t(sf)
  sf <- unique(sf)
  sf <- data.frame(t(unique(sf, MARGIN = 2)))
  rem <- colnames(sf)[-1]
  rownames(sf) <- sf[,1]
  sf <- sf[rem,]
  skills <- dim(sf)[2]-1
  sf <- data.frame(apply(sf[, 2:(skills+1)], 2, as.numeric))
  sf <- cbind(data.frame(rem), sf)
  colnames(sf)[1] <- "Skill"
  sf
}
