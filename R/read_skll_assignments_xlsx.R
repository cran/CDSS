library(openxlsx)
#' Read an assignment of taught and required skills for a set of learning objects from an XLSX-file.
#'
#' \code{read_skill_assignment_xlsx} expects an XLSX-file with two sheets assigning taught and
#' required, respectively, skills to learning objects with two columns each. The first
#' column contains the IDs of learning objects and the second row the IDs of single skills
#' required or taught, respectively, by this learning object.
#' It returns a list of two binary matrices, "taught" and "required". Each matrix has one
#' row per learning object and one column per skill. The cells contain a "1" if the skill
#' is taught or required, respectively, by the learning object and a "0" otherwise,
#'
#' @param filename Name of the XLSX-file
#' @param taughtname Name of the sheet with required assignment (default = "Taught")
#' @param requiredname Name of the sheet with required assignment (default = "Required")
#' @param warnonly Are non-compliant SAs allowed? (default = FALSE)
#' @param verbose Verbosity of compliance test (default = TRUE)
#'
#' @return List of two binary matrices, "taught" and "required".
#' 
#' @importFrom openxlsx read.xlsx
#'
#' @family functions reading skill assignments
#'
#' @export
read_skill_assignment_xlsx <- function(
    filename,
    taughtname = "Taught",
    requiredname = "Required",
    warnonly = FALSE,
    verbose = TRUE
)
{
  t <- read.xlsx(xlsxFile = filename, sheet = taughtname)
  r <- read.xlsx(xlsxFile = filename, sheet = requiredname)
  sa <- cdss_tables2sa(t, r)
  check <- cdss_sa_compliance(sa, verbose)
  if (!check) {
    if (warnonly) {
      stop("The assignment tables are not skill assignment compliant!")
    } else {
      warning("The assignment tables are not skill assignment compliant!")
    }
  }
  sa
}
