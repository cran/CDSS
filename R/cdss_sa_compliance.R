#' Check whether a skill assignment is compliant to the CDCS conditions.
#'
#' \code{cdss_sa_compliance} expects a skill assignment and checks whether
#' it is compliant to the conditions for CDCS.
#'
#' @param sa Skill assignment
#' @param warnings Toggles whether warnings should be printed
#'
#' @return Boolean
#' 
#' @family Functions testing validity of skill assignments
#'
#' @export
cdss_sa_compliance <- function(sa, warnings = FALSE) {
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

  result <- TRUE

  if (any(colSums(taught) == 0)) {
    if (warnings) warning("Not all skills are taught by learning objects: ",
            names(which(colSums(taught) == 0)))
    result <- FALSE
  }

  if (any(required & taught)) {
    is <- rownames(which(required & taught, arr.ind=TRUE))
    if (warnings) warning("Some skills are taught and required for the same learning object: ", is)
    result <- FALSE
  }

  result
}
