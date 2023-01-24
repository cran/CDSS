#' Build matrices of taught and required, respectively, skills for learning objects from
#' respective tables.
#'
#' \code{cdss_tables2sa} expects two data frames with two columns each. The first
#' column contains the IDs of learning objects and the second row the IDs of single skills
#' required or taught, respectively, by this learning object.
#' It returns a list of two binary matrices, "taught" and "required". Each matrix has one
#' row per learning object and one column per skill. The cells contain a "1" if the skill
#' is taught or required, respectively, by the learning object and a "0" otherwise.
#'
#' @param taught Data table containing the assignment of taught skills to learning objects
#' @param required Data table containing the assignment of required skills to learning objects
#'
#' @return List of two binary matrices, "taught" and "required".
#'
#' @family functions building skill (multi) assignment matrices
#'
#' @export
cdss_tables2sa <- function(taught, required) {
  # Doing some awful hack here: blowing up the skill and LO names to 128 chars width
  # and at the end trimming them back - but I did not get it to work otherwise
  skills <- trimws(format(unique(c(taught[,2],required[,2])), width=128, justify="right"), "both")
  los <- trimws(format(unique(c(taught[,1],required[,1])), width=128, justify="right"), "both")
  req <- matrix(data = rep(0, length(skills)*length(los)), nrow = length(los))
  tgt <- matrix(data = rep(0, length(skills)*length(los)), nrow = length(los))
  colnames(req) <- skills
  rownames(req) <- los
  colnames(tgt) <- skills
  rownames(tgt) <- los
  apply(required, MARGIN =1, FUN=function(x){req[trimws(format(x[1], width=35,justify="right"), "both"),
                                                 trimws(format(x[2], width=35,justify="right"), "both")] <<- 1})
  apply(taught, MARGIN =1, FUN=function(x){tgt[trimws(format(x[1], width=35,justify="right"), "both"),
                                               trimws(format(x[2], width=35,justify="right"), "both")] <<- 1})
  l <- list(taught=tgt, required=req)
  class(l) <- unique(c("cdss_sa", class(l)))
  l
}
