#' Create an attribution relation on learning objects from a skill assignment.
#'
#' \code{cdss_lo_sa2ar} expects a skill assignment and derives an attribution relation
#'  on learning objects if the skill assignment fulfills the necessary conditions, i.e. if  
#'  there is only one teaching LO per skill.
#'
#' @param sa Skill assignment object
#'
#' @return attribution relation or NULL
#'
#' @family functions deriving skill structures from skill assignments
#'
#' @export
cdss_lo_sa2ar <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  if (!cdss_sa_describes_sr(sa)) {
    stop(sprintf("%s does not describe a surmise relation!", dQuote("sa")))
  }

  los <- unique(rownames(sa$taught))
  ar <- diag(length(los))
  colnames(ar) <- rownames(sa$taught)
  rownames(ar) <- rownames(sa$taught)
  sapply(rownames(sa$taught), function(lo) {
    sapply(colnames(sa$taught), function(skill) {
      if (sa$required[lo,skill] == 1) {
        lo2 <- names(which(sa$taught[,skill] == 1))
        ar[lo2,lo] <<- 1
      }
    })
  })
  ar
} 