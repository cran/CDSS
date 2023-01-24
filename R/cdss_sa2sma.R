#' Convert skill assignment matrices to skill multi-assignment
#'
#' \code{cdss_sa2sma} expects a list of two matrices (\code{taught} and \code{required}) of a skill
#' assignment. It returns a skill multi-assignment object.
#'
#' @param sa Skill assignment object
#'
#' @return Object of class \code{cdss_sma}.
#'
#' @family functions building skill (multi) assignment matrices
#'
#' @export
cdss_sa2sma <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  df <- cbind(data.frame(rownames(sa$taught)),
              data.frame(sa$taught),
              data.frame(sa$required))
  colnames(df)[1] <- "LO"
  rownames(df) <- NULL
  class(df) <- unique(c("cdss_sma", class(df)))
  df
}
  