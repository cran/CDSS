#' Check whether a surmise relation can be derived from a given skill assignment.
#'
#' \code{cdss_sa_describes_sr} expects a list of two matrices (\code{taught} and \code{required}) of a skill
#' assignment. It returns TRUE if the skill assignment describes a surmise relation (i.e. there is
#' only one teaching LO per skill) and FALSE.
#'
#' @param sa Skill assignment object
#' @param verbose Flag, default is FALSE
#'
#' @return Logical value
#'
#' @family functions deriving skill structures from skill assignments
#'
#' @export
cdss_sa_describes_sr <- function(sa, verbose = FALSE) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  rv <- max(colSums(sa$taught)) == 1
  if ((!rv) & verbose) {
    c <- colnames(sa$taught)[which(colSums(sa$taught) > 1)]
    msg <- paste ("The following skills have more than one teaching LO:", c)
    message(msg)
  }
  rv
}