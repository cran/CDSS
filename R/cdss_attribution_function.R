#' Build an attribution function from CDSS skill assignment matrices.
#'
#' \code{cdss_attribution_function_sa} builds an attribution function from
#' skill assignment matrices using the procedure described by Hockemeyer (2022).
#'
#' @param sa Skill assignment
#'
#' @return Data frame defining the attribution function derived from \code{sa}
#'
#' @export
cdss_attribution_function_sa <- function(sa)
{

  taught <- sa$taught
  required <- sa$required
  
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
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

  if (!(cdss_sa_compliance(taught, required))) {
    stop("The skill assignment does not comply to the CDSS conditions.")
  }

  # Build an attribution function
  r2 <- (required | taught) * 1
  af <- data.frame(NULL)
  sapply(colnames(taught), function(c) {
    sapply(names(which(taught[,c] == 1)), function(l) {
      sapply(names(which(taught[l,]==1)), function(d) {
        af <<- rbind(af, c(d, r2[l,]))
      })
    })
  })
  colnames(af) <- c("Comp.", colnames(required))
  class(af) <- unique(c("af", class(af)))
  af
}



#' Build an attribution function from CDSS skill multi-assignment matrices.
#'
#' \code{cdss_attribution_function_sma} builds an attribution function from
#' skill multi-assignment matrices using the procedure described by Hockemeyer (2022).
#'
#' @param sma Skill multi-assignment
#'
#' @return Data frame defining the attribution function derived from \code{sma}
#'
#' @export
cdss_attribution_function_sma <- function(sma)
{
  
  taught <- sma$taught
  required <- sma$required
  
  if (!(inherits(sma, "cdss_sma"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sma"),
                 dQuote("cdss_sma")))
  }
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
  
  # Build an attribution function
  r2 <- (required | taught) * 1
  af <- data.frame(NULL)
  sapply(colnames(taught), function(c) {
    sapply(names(which(taught[,c] == 1)), function(l) {
      sapply(names(which(taught[l,]==1)), function(d) {
        af <<- rbind(af, c(d, r2[l,]))
      })
    })
  })
  colnames(af) <- c("Comp.", colnames(required))
  class(af) <- unique(c("af", class(af)))
  af
}
