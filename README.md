
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.com/poissonconsulting/dbflobr.svg?branch=master)](https://travis-ci.com/poissonconsulting/dbflobr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/4yop2q92batu2e25/branch/master?svg=true)](https://ci.appveyor.com/project/poissonconsulting/dbflobr/branch/master)
[![Coverage
status](https://codecov.io/gh/poissonconsulting/dbflobr/branch/master/graph/badge.svg)](https://codecov.io/github/poissonconsulting/dbflobr?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Tinyverse
status](https://tinyverse.netlify.com/badge/dbflobr)](https://CRAN.R-project.org/package=dbflobr)
[![CRAN
status](https://www.r-pkg.org/badges/version/dbflobr)](https://cran.r-project.org/package=dbflobr)
![CRAN downloads](http://cranlogs.r-pkg.org/badges/dbflobr)
<!-- badges: end -->

# dbflobr

`dbflobr` reads and writes files to SQLite databases as
[flobs](https://github.com/poissonconsulting/flobr). A flob is a
[blob](https://github.com/tidyverse/blob) that preserves the file
extension.

## Installation

To install the latest release version from
[CRAN](https://cran.r-project.org)

``` r
install.packages("dbflobr")
```

To install the latest development version from
[GitHub](https://github.com/poissonconsulting/dbflobr)

``` r
# install.packages("remotes")
remotes::install_github("poissonconsulting/dbflobr")
```

## Demonstration

``` r
library(dbflobr)

# convert a file to flob using flobr
flob <- flobr::flob(system.file("extdata", "flobr.pdf", package = "flobr"))
str(flob)
#> List of 1
#>  $ /Library/Frameworks/R.framework/Versions/3.6/Resources/library/flobr/extdata/flobr.pdf: raw [1:133851] 58 0a 00 00 ...
#>  - attr(*, "ptype")= raw(0) 
#>  - attr(*, "class")= chr [1:2] "flob" "blob"

# create a SQLite database connection 
conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# create a table 'Table1' of data
DBI::dbWriteTable(conn, "Table1", data.frame(IntColumn = c(1L, 2L)))

# read the table
DBI::dbReadTable(conn, "Table1")
#>   IntColumn
#> 1         1
#> 2         2

# specify which row to add the flob to by providing a key 
key <- data.frame(IntColumn = 1L)

# write the flob to the database in column 'BlobColumn'
write_flob(flob, "BlobColumn", "Table1", key, conn, exists = FALSE)

# read the table
DBI::dbReadTable(conn, "Table1")
#>   IntColumn      BlobColumn
#> 1         1 blob[133.85 kB]
#> 2         2            <NA>

# read the flob
flob2 <- read_flob("BlobColumn", "Table1", key, conn)
str(flob2)
#> List of 1
#>  $ BlobColumn: raw [1:133851] 58 0a 00 00 ...
#>  - attr(*, "class")= chr [1:2] "flob" "blob"

# delete the flob
delete_flob("BlobColumn", "Table1", key, conn)

# read the table
DBI::dbReadTable(conn, "Table1")
#>   IntColumn BlobColumn
#> 1         1       <NA>
#> 2         2       <NA>

# close the connection
DBI::dbDisconnect(conn)
```

## Inspiration

  - [blob](https://github.com/tidyverse/blob)
  - [flobr](https://github.com/poissonconsulting/flobr)

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/dbflobr/issues).

[Pull requests](https://github.com/poissonconsulting/dbflobr/pulls) are
always welcome.

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/poissonconsulting/dbflobr/blob/master/CODE_OF_CONDUCT.md).
By contributing, you agree to abide by its terms.
