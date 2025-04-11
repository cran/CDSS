even <- function(i) {
  if (floor(i/2)*2 == i) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

#' Derive a surmise function between learning objects from a complete skill multi-assignment
#' 
#' \code{cdss_lo_csma2sf} expects a complete skill multi-assignment and derives a surmise
#' function on the set of learning objects.
#' 
#' @param csma Complete skill multi-assignment object
#'
#' @return Object of class \code{cdss_sf} (attribution function).
#'
#' @family functions building skill (multi) assignment matrices
#'
#' @export
cdss_lo_csma2sf <- function(csma) {
  if (!(inherits(csma, "cdss_csma"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("csma"),
                 dQuote("cdss_csma")))
  }
  colcnt <- dim(csma)[2]
  if (even(colcnt)) {
    stop(sprintf("Internal error: A CSMA cannot have an even number of columns!"))
  }
  skillcnt <- colcnt / 2
  tgt <- as.matrix(csma[,2:((skillcnt+1))])
  req <- as.matrix(csma[,((skillcnt+1):dim(csma)[2])])
  rownames(tgt) <- csma[,1]
  rownames(req) <- csma[,1]
  sa <- list(taught = tgt, required=req)
  class(sa) <- unique(c("cdss_sa", class(sa)))
  rtaf <- cdss_lo_sa2af(sa)
  chgd <- TRUE
  locnt <- dim(rtaf)[2]-1
  LOs <- colnames(rtaf)[-1]
  rtaf[,2:(locnt+1)] <- sapply(rtaf[,2:(locnt+1)], as.numeric)
  while (chgd) {
    chgd <- FALSE
    sapply(LOs, function(l) {
      if (!chgd) {
        sel <- which(rtaf[,1]==l) 
        lapply(sel, function(x) {
          if (!chgd) {
            lapply(sel, function(y) {
              if ((!chgd) & (x != y)) {
                if (all((rtaf[x,2:(locnt+1)] & rtaf[y,2:(locnt+1)]) == rtaf[x,2:(locnt+1)])) {
                  rtaf <<- rtaf[-y,]
                  chgd <<- TRUE
                }
              }
            })
          }
        })
      } 
    })
  }
  class(rtaf) <- c("cdss_sf", class(rtaf))
  rtaf
}