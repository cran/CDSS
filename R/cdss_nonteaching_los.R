#' Vector of learning objects not teaching any skills.
#'
#' \code{cdss_nonteaching_los} expects a skill assignment and returns a vector
#' of learning objects which do not teach any skill.
#'
#' @param sa SKill assignment
#'
#' @return Vector of learning objects
#' 
#' @family Functions testing validity of skill assignments
#'
#' @export
cdss_nonteaching_los <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  taught <- sa$taught
  required <- sa$required
  
  # Checks if matrices fit together
  if (!(all(dim(taught) == dim(required)))) {
    stop(sprintf("%s and %s must have equal size!", dQuote("taught", dQuote("required"))))
  }
  if (!(all(colnames(required) == colnames(taught)))) {
    stop(sprintf("%s and %s must have equal colnames!", dQuote("taught", dQuote("required"))))
  }
  if (!(all(rownames(required) == rownames(taught)))) {
    stop(sprintf("%s and %s must have equal rownames!", dQuote("taught", dQuote("required"))))
  }

  names(which(rowSums(taught) == 0))

}
