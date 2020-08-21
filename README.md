
<!-- README.md is generated from README.Rmd. Please edit that file -->

# githubclassroom

<!-- badges: start -->

<!-- badges: end -->

Minimal R package for downloading and managing GitHub Classrooms from R.

## Installation

<!-- You can install the released version of githubclassroom from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("githubclassroom") -->

<!-- ``` -->

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mitchelloharawild/githubclassroom")
```

## Usage

The main function from this package is `clone_assignments()`. It can be
used to clone all of the assignment submissions for a given assignment
and organisation to a particular path.

``` r
library(githubclassroom)
clone_assignments("~/teaching/ETC5523/assignment_1", 
                  assignment = "take-home-assignment",
                  organisation = "etc5523-2020")
```

You can also report progress using `with_progress()` from the
[progressr](https://github.com/HenrikBengtsson/progressr) package:

``` r
library(progressr)
with_progress(clone_assignments(...))
```
