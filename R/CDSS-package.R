#' CDSS: Course dependent skill structures
#' 
#' The \code{CDSS} package provides functions for a complete workflow from
#' skill assignment tables to surmise mappings on the sets of skills and
#' learning objects, respectively.
#'
#' @section Suggested workflow for the general case:
#' 1. Read the skill assignment using one of the \code{read_skill_assignments_xxx()} functions.
#' 1. Check the compliance to the definition for skill assignments using [cdss_sa_compliance()].
#' 1. Convert the skill assignment into a skill multi-assignment using [cdss_sa2sma()].
#' 1. Close the skill multi-assignment under completion using [cdss_sma2csma()].
#' 1. Compute the surmise function on skills using [cdss_csma2sf()].
#' 1. Continue with functions from the \code{kstMatrix} package, e.g., to obtain a basis and further on a skill space.
#' 
#' @section Suggested workflow for the special case of one LO per skill:
#' 1. Read the skill assignment using one of the \code{read_skill_assignments_xxx()} functions.
#' 1. Check whether the skill assignment allows for the derivation of a surmise relation using [cdss_sa_describes_sr()].
#' 1. If yes, derive an attribution relation from the skill assignment using [cdss_sa2ar_skill()].
#' 1. Close the attribution relation to a surmise relation using [cdss_close_ar()].
#' 1. Continue with functions from the \code{kstMatrix} package, e.g., to obtain a basis and further on a skill space.
#' 
#' @section Data files:
#' The installation of this package includes several data files as examples in the
#' \code{extdata} sub directory (see the Examples below for how to access the files there). 
#' There are four data sets, \code{KST}, \code{KST-Intro}, \code{SkillAssignment}, and
#' \code{ErroneousSkillAssignment}. The \code{SkillAssignment} data set is available in 
#' three formats, ODS, XLSX, and CSV (in CSV format, there are two files each, 
#' \code{SkillAssignment-R.csv} and \code{SkillAssignment-T.csv}, for required and taught skills, respectively).
#' The other three data sets are available in ODS format only.
#' 
#' \code{SkillAssignment} and \code{ErroneousSkillAssignment} are small example data sets
#' where the latter fails for \code{cdss_sa_compliance()}. \code{KST} contains a skill
#' assignment for the course on knowledge space theory under <https://moodle.qhelp.eu/>.
#' \code{KST-Intro} contains the reduction of \code{KST} to the first chapter of
#' that course.
#' 
#' @examples
#' library(readODS)
#' fpath <- system.file("extdata", "SkillAssignment.ods", package="CDSS")
#' sa <- cdss_read_skill_assignment_ods(fpath)
#' sa
#' sma <- cdss_sa2sma(sa)
#' sma
#' csma <- cdss_sma2csma(sma)
#' csma
#' sf <- cdss_csma2sf(csma)
#' sf
#'
#' @section References:
#' Hockemeyer, C. (2022). Building Course-Dependent Skill Structures - Applying
#' Competence based Knowledge Space Theory to Itself. Manuscript in preparation.
#' 
#' @section Acknowledgements:
#' The creation of this R package was financially supported by the Erasmus+ Programme
#' of the European Commission through the QHELP project (<https://qhelp.eu/>).
#'
#' @aliases CDSS-package
#' @md
#' @name CDSS
NULL
