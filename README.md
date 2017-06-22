# jfars package

The jfars package is my version of the FARS data for the Johns Hopkins R Packages course on Coursera.

Travis CI 
[![Travis-CI Build Status](https://travis-ci.org/jayrbrown/jfars.svg?branch=master)](https://travis-ci.org/jayrbrown/jfars)

AppVeyor 
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/jayrbrown/jfars?branch=master&svg=true)](https://ci.appveyor.com/project/jayrbrown/jfars)


## Install

Install jfars from github using devtools.

```r
install.packages("devtools")
library(devtools)
install_github("jayrbrown/jfars")
```

## Dependencies

The jfars package depends on several standard R packages you may already have installed. These need to all be loaded prior to running the jfars functions.

* dplyr
* tidyr
* readr 
* maps 

## Data Source

The data originates from the National Highway Traffic Safety Administration (NHTSA). A sample of the data will be installed with the jfars package.

https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars

# Sample Data

`r system.file("extdata", "fars_data.zip", package="jfars")`

