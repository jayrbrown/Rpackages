# tests for fars package

# fars_read
test_that("fars_read", {
    expect_that(fars_read(2013), is_a("tbl"))
    expect_that(fars_read(), throws_error())
})

# make_filename
test_that("make_filename", {
    expect_that(make_filename(2013), matches("(accident_)\d{4}(.csv.bz2)"))
})

# fars_read_years
test_that("fars_read_years", {
    expect_that(fars_read_years(2013), is_a("dataframe"))
    expect_that(fars_read_years(2017), throws_error())
})

# fars_summarize_years 
test_that("fars_summarize_years", {
    expect_that(fars_summarize_years(2013), iss_a("dataframe"))
})

# fars_map_state
test_that("fars_map_state", {
    expect_that(fars_map_state(999, 2013), throws_error())
    expect_that(fars_map_state(10, 2017), shows_message("no accidents to plot"))
})

