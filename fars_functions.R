#' fars_read
#'
#' This function accepts a filename argument and opens the file using 
#' the readr library then creates a data frame tbl. Typically used as 
#' a private function. 
#' 
#' If the file noted does not exist it will error saying so. 
#' If there is an error reading the file it will fail and there will 
#' be no error message.
#' 
#' @param filename A string representing the path to the file.
#' 
#' @return A data frame tbl.
#' 
#' @importFrom readr read_csv 
#' @importFrom dplyr tbl_df
#' 
#' @examples 
#' \dontrun{
#' df <- fars_read(filename = myfile)
#' df <- fars_read(myfile)
#' }
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' make_filename
#' 
#' This function generates a filename using a base string and adding a year 
#' passed via argument. The filename produced reflects the naming used in the 
#' fars data. Typically used as a private function.
#' 
#' Note this function does not consider the source data is in a directory and the 
#' likelihood the script is outside the directory. This is addressed by setting 
#' the working directory to be the data directory.
#' 
#' @param year A string or integer value of the year to add to the filename.
#' 
#' @return A string being a modified filename for assignment.
#'  
#' @examples 
#' \dontrun{
#' new_name <- make_filename(year = 2017)
#' new_name <- make_filename(2017)
#' }
#' @export  
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' fars_read_years
#' 
#' This function takes a vector of years as an argument and cycles through
#' elements. For each element found in the vector, it generates a filename, 
#' reads the file of the new name, creates a new column in the data frame 
#' for the year, and finally returns a data frame having only the columns 
#' month and year.
#' 
#' As noted in make_filename, this function does not reflect the potential 
#' of error given the data files reside in a data directory and the script 
#' likely resides outside of the directory. This is addressed by setting the 
#' working directory to be the data directory.
#' 
#' If the years vector has years for which there is no data it will display a warning.
#' 
#' @param years A vector of years.
#' 
#' @return A list of data frames, one for each file.
#' 
#' @importFrom dplyr mutate, select
#' 
#' @examples 
#' \dontrun{
#' df <- fars_read_years(years = c(2010:2017))
#' df <- fars_read_years(c(2010:2017))
#' }
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>% 
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' fars_summarize_years
#' 
#' This function takes a vector of years and reads data from derived filenames 
#' then summarizes the number of observations for each year grouped by month. 
#' It transforms the data to wide format and returns this as a data frame.
#' 
#' @param years A vector of years.
#' 
#' @return A wide dataframe of the number of observations by month and year.
#' 
#' @importFrom dplyr bind_rows, group_by, summarize
#' @importFrom tidyr spread 
#' 
#' @examples 
#' \dontrun{
#' df <- fars_summarize_years(years = c(2010:2017))
#' df <- fars_summarize_years(c(2010:2017))
#' }
#' @export 
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>% 
                dplyr::group_by(year, MONTH) %>% 
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' fars_map_state
#' 
#' This function takes the supplied state number and year and plots the  
#' locations of accidents on a map outlining the specified state.
#' 
#' Note the maps library must be loaded in the session else it may fail.
#' 
#' If an invalid state number is supplied it will error saying this.
#' 
#' If there are no accidents to plot, it will return null.
#' 
#' @param state.num An integer representing the state identifier.
#' @param year An integer of the year to reference for mapping.
#' 
#' @return A map plot showing accidents in the state within the year.
#' 
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#' 
#' @examples 
#' \dontrun{
#' map <- fars_map_state(state.num = 10, year = 2017)
#' map <- fars_map_state(10, 2017)
#' }
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
