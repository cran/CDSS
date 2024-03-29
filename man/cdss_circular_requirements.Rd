% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cdss_circular_requirements.R
\name{cdss_circular_requirements}
\alias{cdss_circular_requirements}
\title{Vector of learning objects requiring and teaching the same skill}
\usage{
cdss_circular_requirements(sa)
}
\arguments{
\item{sa}{Skill assignment}
}
\value{
Vector of learning objects
}
\description{
\code{cdss_circular_requirements} expects skill assignment and returns
a vector of learning objects which require a skill that they teach.
}
\seealso{
Other Functions testing validity of skill assignments: 
\code{\link{cdss_missing_los}()},
\code{\link{cdss_nonteaching_los}()},
\code{\link{cdss_sa_compliance}()}
}
\concept{Functions testing validity of skill assignments}
