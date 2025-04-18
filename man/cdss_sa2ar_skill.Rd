% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdss_sa2ar_skill.R
\name{cdss_sa2ar_skill}
\alias{cdss_sa2ar_skill}
\title{Create an attribution relation on skills from a skill assignment.}
\usage{
cdss_sa2ar_skill(sa)
}
\arguments{
\item{sa}{Skill assignment object}
}
\value{
attribution relation or NULL
}
\description{
\code{cdss_sa2ar_skill} expects a skill assignment and derives an attribution relation
 on skills if the skill assignment fulfills the necessary conditions, i.e. if there 
 is only one teaching LO per skill.
}
\seealso{
Other functions deriving skill structures from skill assignments: 
\code{\link{cdss_lo_sa2ar}()},
\code{\link{cdss_sa_describes_sr}()}
}
\concept{functions deriving skill structures from skill assignments}
