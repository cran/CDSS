#' Close an attribution relation to get a surmise relation.
#'
#' \code{close_ar} expects a quadratic binary matrix and closes it under
#' reflexivity and transitivity.
#'
#' @param ar Attribution relation matrix
#'
#' @return surmise relation or NULL
#'
#' @family Utility functions
#'
#' @export
close_ar <- function(ar) {
  if (!(inherits(ar, "matrix"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("ar"),
                 dQuote("matrix")))
  }
  if ((max(ar) > 1) || (min(ar) < 0)) {
    stop(sprintf("%s is not a binary matrix!", dQuote("ar")))
  }
  size <- dim(ar)[1]
  if (size != dim(ar)[2]) {
    stop(sprintf("%s is not a uqadratic matrix!", dQuote("ar")))
  }
  
  # Close ar under reflexivity
  d <- diag(1,size,size)
  ar <- 1 * (ar | d)

  # Close ar under transitivity
  sr <- binary_matrix_product(ar, ar)
  sr.old <- ar
  while(any(sr != sr.old)) {
    sr.old <- sr
    sr <- binary_matrix_product(sr, sr)
  }
  colnames(sr) <- colnames(ar)
  rownames(sr) <- rownames(ar)
  class(sr) <- unique(c("surmise_relation", "attribution_relation", class(sr)))
  sr
}