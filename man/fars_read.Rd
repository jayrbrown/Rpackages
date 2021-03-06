% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read}
\alias{fars_read}
\title{fars_read}
\usage{
fars_read(filename)
}
\arguments{
\item{filename}{A string representing the path to the file.}
}
\value{
A data frame tbl.
}
\description{
This function accepts a filename argument and opens the file using 
the readr library then creates a data frame tbl. Typically used as 
a private function.
}
\details{
If the file noted does not exist it will error saying so. 
If there is an error reading the file it will fail and there will 
be no error message.
}
\examples{
\dontrun{
df <- fars_read(filename = myfile)
df <- fars_read(myfile)
}
}
