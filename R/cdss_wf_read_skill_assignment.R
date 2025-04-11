library(readODS)
library(openxlsx)
library(tools)
#' Read an assignment of taught and required skills for a set of learning objects from file and
#' do the whole workflow up to a surmise function on skills
#'
#' \code{cdss_wf_read_skill_assignment} expects an ODS or XLSX file with two sheets assigning 
#' taught and required, respectively, skills to learning objects with two columns each. 
#' Alternatively, two CSV files can be specified. In the sheets/CSV files, the first
#' column contains the IDs of learning objects and the second row the IDs of single skills
#' required or taught, respectively, by this learning object.
#' It returns a list of two binary matrices, "taught" and "required". Each matrix has one
#' row per learning object and one column per skill. The cells contain a "1" if the skill
#' is taught or required, respectively, by the learning object and a "0" otherwise,
#'
#' @param filename Name of the file (in case of CSV files the one with TAUGHT assignments)
#' @param filename2 Name of the CSV file with REQUIRED assignments (if applicable)
#' @param filetype Type of the file, allowed values are "auto", "ODS", "XLSX", and "CSV"
#' @param taughtname Name of the sheet with required assignment (default = "Taught")
#' @param requiredname Name of the sheet with required assignment (default = "Required")
#' @param header Boolean specifying whether the CSV-files contain a header line (default = TRUE)
#' @param sep Column separator for CSV files (default ",")
#' @param dec Decimal point character for CSV files (default ".")
#' @param warnonly Are non-compliant SAs allowed? (default = FALSE)
#' @param verbose Verbosity of compliance test (default = TRUE)
#'
#' @return List of four elements: sfs (surmise function between skills),
#'                                sfl (surmise function between learning objects)
#'                                srs (surmise relation between skills, if available; NULL otherwise)
#'                                srl (surmise relation between learning objectrs, if available; NULL otherwise)
#' 
#' @importFrom readODS read_ods
#' @importFrom tools file_ext
#' @importFrom utils read.csv
#' @importFrom openxlsx read.xlsx
#' 
#' @family functions reading skill assignments
#'
#' @export
cdss_wf_read_skill_assignment <- function(
    filename,
    filename2 = NULL,
    filetype = "auto",
    taughtname = "Taught",
    requiredname = "Required",
    header = TRUE,
    sep = ",",
    dec = ".",
    warnonly = FALSE,
    verbose = TRUE
)
{
 if (filetype == "auto") {
   if (!(is.null(filename2))) {
     filetype = "CSV"
     sa <- cdss_read_skill_assignment_csv(filename, filename2, header, sep, dec, warnonly, verbose)
   } else {
     ext <- tolower(file_ext(filename))
     if (ext == "ods") {
       filetype <- "ODS"
       sa <- cdss_read_skill_assignment_ods(filename, taughtname, requiredname, warnonly, verbose)
     } else if (ext == "xlsx") {
       filetye <- "XLSX"
       sa <- cdss_read_skill_assignment_xlsx(filename, taughtname, requiredname, warnonly, verbose)
     } else if (ext == "csv")
       stop("For CSV filetype, two filenames must be specified!")
     else
       stop("Unknown filetype specified!")
   }
 }
  sma <- cdss_sa2sma(sa)
  csma <- cdss_sma2csma(sma)
  sfs <- cdss_csma2sf(csma)
  sfl <- cdss_lo_csma2sf(csma)
  if (cdss_sa_describes_sr(sa)) {
    srs <- cdss_sa2ar_skill(sa)
    srl <- cdss_lo_sa2ar(sa)
  } else {
    srs <- NULL
    srl <- NULL
  }
  list (sfs=sfs, sfl=sfl, srs=srs, srl=srl)
}
  