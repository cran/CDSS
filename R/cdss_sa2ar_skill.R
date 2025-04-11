#' Create an attribution relation on skills from a skill assignment.
#'
#' \code{cdss_sa2ar_skill} expects a skill assignment and derives an attribution relation
#'  on skills if the skill assignment fulfills the necessary conditions, i.e. if there 
#'  is only one teaching LO per skill.
#'
#' @param sa Skill assignment object
#'
#' @return attribution relation or NULL
#'
#' @family functions deriving skill structures from skill assignments
#'
#' @export
cdss_sa2ar_skill <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  if (!cdss_sa_describes_sr(sa)) {
    stop(sprintf("%s does not describe a surmise relation!", dQuote("sa")))
  }
  
  # Determine attribution relation
  skills <- dim(sa$taught)[2]
  ar <- diag(1, skills, skills)
  lapply(rownames(sa$taught), function(x) {
    sapply((1:skills), function(y) {
      if (sa$taught[x,y]) {
        sapply((1:skills), function(z) {
          if (sa$taught[x,z]) {ar[y,z] <<- 1}
        })
        sapply((1:skills), function(z) {
          if (sa$required[x,z]) {ar[y,z] <<- 1}
        })
      }
    })
  })
  colnames(ar) <- colnames(sa$taught)
  rownames(ar) <- colnames(sa$taught)
  class(ar) <- unique(c("attribution_relation", class(ar)))
  t(ar)
}