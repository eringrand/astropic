
<!-- README.md is generated from README.Rmd. Please edit that file -->
apodR
=====

The goal of apodR is to connect R to the NASA APOD API. The APOD API supports one image at a time. In order to suplly more than that, this package also includes creating time ranges (of less than 1000 days ata time) and some historical data in tibble format.

Installation
------------

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("eringrand/apodR")
```

Example
-------

This is a basic example to retrive APOD data. If you do not give an end date, it will assume you want up untill today.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(apodR)
get_apod(start_date = "2018-04-03")
#> # A tibble: 1 x 8
#>   copyright date  explanation hdurl media_type service_version title url  
#>   <chr>     <chr> <chr>       <chr> <chr>      <chr>           <chr> <chr>
#> 1 Sergei M~ 2018~ You may ha~ http~ image      v1              The ~ http~
```
