#' Complete a skill multi-assignment
#'
#' \code{cdss_sma2csma} expects a skill multi-assignment object and returns
#' the corresponding complete skill multi-assignment. 
#' If this would involve cycles, the function stops by default - except if 
#' \code{allowcycles} is set to \code{TRUE}. In that case, the result may
#' be ill-defined!
#'
#' @param sma Skill multi-assignment to be completed
#' @param allowcycles Whether prerequisite cycles should be allowed (default = FALSE)
#'
#' @return Object of class \code{cdss_csma}.
#'
#' @export
cdss_sma2csma <- function(sma, allowcycles = FALSE) {
  if (!(inherits(sma, "cdss_sma"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sma"),
                 dQuote("cdss_sma")))
  }

  skills <- (dim(sma)[2] - 1) / 2
  reqcols <- (skills+2):((2*skills)+1)
  cn <- colnames(sma)
  
  # We do only/max. one addition per outer loop
  chgd <- TRUE
  foundcycles <- FALSE
  clo <- NULL  # chgd LO
  while (chgd && (!foundcycles)) {
    # loop for a transitive extension
    chgd <- FALSE
    clauses <- dim(sma)[1]
    # for each row in the data frame
    lapply((1:clauses), function(cl) {
      if ((!chgd) && (!foundcycles)) {
        if (allowcycles) {
          cl_h <- 1 * (as.numeric(sma[cl,2:(skills+1)]) | as.numeric(sma[cl,(skills+2):((2*skills)+1)]))
        } else {
          cl_h <- as.numeric(sma[cl,(skills+2):((2*skills)+1)])
        }
        # for each required skill
        lapply(which(sma[cl,reqcols]==1), function(s) {
          if ((!chgd) && (!foundcycles)) {
            # possible extensions, i.e. rows for LOs teaching skill s
            poss_rows <- which(sma[,s+1] == 1)
            poss <- 1 * (sma[poss_rows,2:(skills+1)] | sma[poss_rows,(skills+2):((2*skills)+1)])
            # do we have any possible extension already included in cl_h?
            if (any(apply(poss, 1, function(p) {all(1*(p & cl_h) == p)}))) {
            } else {
              chgd <<- TRUE
              tgt <- 1 * (sma[cl,2:(skills+1)])
              req <- 1 * (sma[cl,(skills+2):((2*skills)+1)])
              clo <<- unlist(sma[cl,1])
              sma <<- sma[-cl,]
              apply(poss, 1, function(p) {
                if ((allowcycles) || (all((tgt & p) == 0))) {
                  v <- c(clo, tgt, 1*(req|p))
                  names(v) <- colnames(sma)
                  sma <<- data.frame(rbind(sma, t(v)))
                  sma[,2:(2*skills+1)] <<- sapply(sma[,2:(2*skills+1)], as.numeric)
                  rownames(sma) <<- 1:dim(sma)[1]
                } else
                  foundcycles <<- TRUE
              })
              if ((!allowcycles) && foundcycles) {
                stop(sprintf("Cycle(s) around LO %s! Result is undefined", clo))
              }
            }
          }
        })
      }
    })
    if ((!allowcycles) && foundcycles)
      return()
    # Remove comparable rows
    colnames(sma) <- cn
    rownames(sma) <- 1:(dim(sma)[1])
    if (chgd) {
      ch2 <- TRUE
      while (ch2) {
        rownames(sma) <- 1:(dim(sma)[1])
        ch2 <- FALSE
        sel <- which(sma[,1] == clo)
        lapply(sel, function(x) {
          if (!ch2) {
            lapply(sel, function(y) {
              if (!ch2) {
                if (x != y) {
                  if (all((sma[x,reqcols] & sma[y,reqcols]) == sma[x,reqcols])) {
                    sma <<- sma[-y,]
                    ch2 <<- TRUE
                  } else {
                  }
                }
              }
            })
          }
        })
        colnames(sma) <- cn
        rownames(sma) <- 1:(dim(sma)[1])
      }
    }
  }
  # Final touches to the result
  colnames(sma) <- cn
  rownames(sma) <- 1:(dim(sma)[1])
  class(sma) <- unique(c("cdss_csma", "cdss_sma", class(sma)))
  sma
} 
