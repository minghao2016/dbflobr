% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import.R
\name{import_all_flobs}
\alias{import_all_flobs}
\title{Import all flobs.}
\usage{
import_all_flobs(conn, dir = ".", sep = "_-_", exists = FALSE, replace = FALSE)
}
\arguments{
\item{conn}{A SQLite connection object.}

\item{dir}{A string of the path to the directory to import the files from.
Files need to be within nested folders like 'table1/column1/a.csv'.
This structure is created automatically if save_all_flobs() function is used.}

\item{sep}{A string of the separator between values in file names.}

\item{exists}{A logical scalar specifying whether the column must (TRUE) or
mustn't (FALSE) already exist or whether it doesn't matter (NA).
IF FALSE, a new BLOB column is created.}

\item{replace}{A logical scalar indicating whether to replace existing flobs (TRUE) or not (FALSE).}
}
\value{
An invisible named list indicating directory path,
file names and whether files were successfully written to database.
}
\description{
Import \code{\link[flobr]{flob}}s to SQLite database from directory.
Table and column names are matched to directory names within main directory.
Values in file names are matched to table primary key to determine where to write flob.
}
\examples{
conn <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
DBI::dbGetQuery(conn, "CREATE TABLE Table1 (CharColumn TEXT PRIMARY KEY NOT NULL)")
DBI::dbWriteTable(conn, "Table1", data.frame(CharColumn = c("a", "b")), append = TRUE)
flob <- flobr::flob_obj
write_flob(flob, "BlobColumn", "Table1", data.frame(CharColumn = "a"), conn)
dir <- file.path(tempdir(), "import_all")
save_all_flobs(conn = conn, dir = dir)
import_all_flobs(conn, dir, exists = TRUE, replace = TRUE)
DBI::dbDisconnect(conn)
}
