% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/permuted.R
\name{permuted}
\alias{permuted}
\title{Permuted Split Half}
\usage{
permuted(df.split, iteration, nc, sub, vars)
}
\arguments{
\item{df.split}{A list of split datasets}

\item{iteration}{Number of iterations}

\item{nc}{Number of CPU threads to use}

\item{sub}{Column identifying the subject}

\item{vars}{Variables to be considered}
}
\value{
Returns the result of the permuted split
}
\description{
Permuted Split Half
}
