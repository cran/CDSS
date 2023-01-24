#' Derive a surmise function from a complete skill multi-assignment
#'
#' \code{cdss_csma2sf} expects a complete skill multi-assignment object 
#' and returns the corresponding surmise function on the set of skills.
#'
#' @param csma Skill multi-assignment to be completed
#'
#' @return Object of class \code{cdss_csma}.
#'
#' @export
cdss_csma2sf <- function(csma) {
  if (!(inherits(csma, "cdss_csma"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("csma"),
                 dQuote("cdss_csma")))
  }
  # First, we start with an attribution function.
  # This AF will be closed under reflexivity and transitivity because
  #   we start this from a CSMA.
  skills <- (dim(csma)[2] - 1) / 2
  tgtcols <- 2:(skills+1)
  reqcols <- (skills+2):(2*skills+1)
  
#  sl <- colnames(csma)[tgtcols]
  sf <- data.frame(t(c("xyz", 1:skills))) # We will delete this row later
  colnames(sf) <- 1:(skills+1)
  lapply(1:skills, function(s) {
    currskill <- colnames(csma)[s+1]
    clausenums <- which(csma[,s+1]==1)
    m1 <- matrix(rep(currskill, length(clausenums)),ncol = 1)
    m2 <- 1 * (csma[clausenums,tgtcols] | csma[clausenums,reqcols])
    hf <- data.frame(cbind(m1, m2))
    colnames(hf) <- 1:(skills+1)
    sf <<- rbind(sf, hf)
  })
  sf <- sf[-1,]
  # Now we have to reach incomparability
  chgd <- TRUE
  sf[,2:(skills+1)] <- sapply(sf[,2:(skills+1)], as.numeric)
  while (chgd) {
    chgd <- FALSE
    rownames(sf) <- 1:dim(sf)[1]
    lapply(unique(sf[,1]), function(s) {
      if (!chgd) {
        sel <- which(sf[,1] == s)
        lapply(sel, function(x) {
          if (!chgd) {
            lapply(sel, function(y) {
              if (!chgd) {
                if (x != y) {
                  if (all((sf[x,2:(skills+1)] & sf[y,2:(skills+1)]) == sf[x,2:(skills+1)])) {
                    sf <<- sf[-y,]
                    chgd <<- TRUE
                  }
                }
              }
            })
          }
        })
      }
    })
  }
  colnames(sf) <- c("Skill", colnames(csma)[tgtcols])
  class(sf) <- unique(c("cdss_sf", class(sf)))
  sf
}