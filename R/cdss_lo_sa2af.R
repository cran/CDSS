recurseList <- function(skills, hmat, tgt) {
  if ((is.null(skills)) || (length(skills) == 0)) return(hmat)
  if (length(skills) > 1) {
    currSkill <- skills[1]
    restskills <- skills[2:length(skills)]
  } else {
    currSkill <- skills
    restskills = NULL
  }
  LOs <- rownames(tgt)[which(tgt[,currSkill]==1)]
  if (length(LOs) == 1) LOs <- list(LOs)
  result = matrix(, ncol = dim(hmat)[2], nrow = 0)
  colnames(result) <- colnames(hmat)
  sapply(LOs, function(x) {
    bmat <- hmat
    bmat[,x] <- 1
    bmat <- recurseList(restskills, bmat, tgt)
    result <<- rbind(result, bmat)
  })
  return(result)
}

#' Determine Attribution function for LOs from a skill assignment
#' 
#' \code{cdss_lo_sa2af} expects a skill assignment and derives an attribution
#' function on the set of learning objects.
#' 
#' @param sa Skill assignment object
#'
#' @return Object of class \code{cdss_af} (attribution function).
#'
#' @family functions building skill (multi) assignment matrices
#'
#' @export
cdss_lo_sa2af <- function(sa) {
  if (!(inherits(sa, "cdss_sa"))) {
    stop(sprintf("%s must be of class %s.",
                 dQuote("sa"),
                 dQuote("cdss_sa")))
  }
  req <- sa$required
  tgt <- sa$taught
  countLO <- dim(req)[1]
  af <- data.frame(t(c("xyz", 1:countLO))) # We will delete this row later
  colnames(af) <- c("LO", rownames(req))
  sapply(rownames(req), function(x) {
    skills <- names(which(req[x,]==1))
    hmat <- matrix(rep(0, countLO), nrow=1)
    colnames(hmat) <- rownames(tgt)
    hmat[1,x] <- 1
    hmat <- recurseList(skills, hmat, tgt)
    len <- dim(hmat)[1]
    los <- data.frame(matrix(rep(x, len), ncol=1))
    colnames(los) <- c("LO")
    af <<- rbind(af, cbind(los, hmat))
  })
  colnames(af) <- c("LO", rownames(req))
  class(af) <- unique(c("cdss_af", class(af)))
  return(af[-1,])
}