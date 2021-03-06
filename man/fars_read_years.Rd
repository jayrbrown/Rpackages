% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read_years}
\alias{fars_read_years}
\title{fars_read_years}
\usage{
fars_read_years(years)
}
\arguments{
\item{years}{A vector of years.}
}
\value{
A list of data frames, one for each file.
}
\description{
This function takes a vector of years as an argument and cycles through
elements. For each element found in the vector, it generates a filename, 
reads the file of the new name, creates a new column in the data frame 
for the year, and finally returns a data frame having only the columns 
month and year.
}
\details{
As noted in make_filename, this function does not reflect the potential 
of error given the data files reside in a data directory and the script 
likely resides outside of the directory. This is addressed by setting the 
working directory to be the data directory.

If the years vector has years for which there is no data it will display a warning.
}
\examples{
\dontrun{
df <- fars_read_years(years = c(2010:2017))
df <- fars_read_years(c(2010:2017))
}
}
