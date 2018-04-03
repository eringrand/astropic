
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

This is a basic example to retrive APOD data.

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
library(DT)
get_apod() # no imputs will get today's image
#> [1] "Your remaining API request limit this hour is 231"
#> # A tibble: 1 x 8
#>   copyright date  explanation hdurl media_type service_version title url  
#>   <chr>     <chr> <chr>       <chr> <chr>      <chr>           <chr> <chr>
#> 1 Sergei M~ 2018~ You may ha~ http~ image      v1              The ~ http~
```

With a little `magick` you can also save the APOD image to your computer for use later. This is a demostration of a picture in APOD I helped to create!

``` r
library(magick)
#> Linking to ImageMagick 6.9.9.14
#> Enabled features: cairo, freetype, fftw, ghostscript, lcms, pango, rsvg, webp
#> Disabled features: fontconfig, x11
library(gmp)
#> 
#> Attaching package: 'gmp'
#> The following objects are masked from 'package:base':
#> 
#>     %*%, apply, crossprod, matrix, tcrossprod
library(stringr)

save_image <- function(url){
  image <- try(image_read(url), silent = FALSE)
  image_name <- stringr::str_extract(m31$hdurl, "([^\\/]+$)")
  image_loc <- here::here("man/figures/README", image_name)
  if(class(image)[1] != "try-error"){
    image %>%
    image_write(image_loc)
  }
  return(image)
}

m31 <- get_apod(start_date = "2009-09-17") 
#> [1] "Your remaining API request limit this hour is 230"
pull(m31, explanation)
#> [1] "Taken by a telescope onboard NASA's Swift satellite, this stunning vista represents the highest resolution image ever made of the Andromeda Galaxy (aka M31) - at ultraviolet wavelengths. The mosaic is composed of 330 individual images covering a region 200,000 light-years wide. It shows about 20,000 sources, dominated by hot, young stars and dense star clusters that radiate strongly in energetic ultraviolet light. Of course, the Andromeda Galaxy is the closest large spiral galaxy to our own Milky Way, at a distance of some 2.5 million light-years. To compare this gorgeous island universe's appearance in optical light with its ultraviolet portrait, just slide your cursor over the image.   digg_url ='http://apod.nasa.gov/apod/ap090917.html'; digg_skin = 'compact';"
save_image(m31$hdurl)
```

<img src="C:\Users\ERIN~1.GRA\AppData\Local\Temp\Rtmp2LvkVX\file4280100c1c05.png" width="100%" />

![](man/figures/README/Swift_M31_large_UV70p.jpg)
