#' Vector of learning objects requiring and teaching the same skill
#'
#' \code{cdss_circular_requirements} expects skill assignment and returns
#' a vector of learning objects which require a skill that they teach.
#'
#' @param sa Skill assignment
#'
#' @return Vector of learning objects
#' 
#' @family Functions testing validity of skill assignments
#'
#' @export
cdss_circular_requirements <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  required <- sa$required
  taught <- sa$taught
  
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

  rownames(which(required & taught, arr.ind=TRUE))
}
