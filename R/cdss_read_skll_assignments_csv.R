#' Read an assignment of taught and required skills for a set of learning objects from CSV-files.
#'
#' \code{cdss_read_skill_assignment} expects two CSV-files with two columns each. The first
#' column contains the IDs of learning objects and the second row the IDs of single skills
#' required or taught, respectively, by this learning object.
#' It returns a list of two binary matrices, "taught" and "required". Each matrix has one
#' row per learning object and one column per skill. The cells contain a "1" if the skill
#' is taught or required, respectively, by the learning object and a "0" otherwise,
#'
#' @param taught CSV-file with assignments of taught competencies to learning objects
#' @param required CSV-file with assignments of required competencies to learning objects
#' @param header Boolean specifying whether the CSV-files contain a header line (default = TRUE)
#' @param sep Column separator (default ",")
#' @param dec Decimal point character (default ".")
#' @param warnonly Are non-compliant SAs allowed? (default = FALSE)
#' @param verbose Verbosity of compliance test (default = TRUE)
#'
#' @return List of two binary matrices, "taught" and "required".
#' 
#' @importFrom utils read.csv
#'
#' @family functions reading skill assignments
#'
#' @export
cdss_read_skill_assignment_csv <- function(
    taught,
    required,
    header = TRUE,
    sep = ",",
    dec = ".",
    warnonly = FALSE,
    verbose = TRUE
    )
{
  t <- read.csv(taught, header=header, sep=sep, dec=dec, fill=FALSE)
  r <- read.csv(required, header=header, sep=sep, dec=dec, fill=FALSE)
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
