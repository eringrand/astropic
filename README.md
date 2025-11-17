
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- <!-- badges: start -->

–\>
<!-- [![Travis build status](https://travis-ci.org/eringrand/astropic.svg?branch=master)](https://travis-ci.org/eringrand/astropic) -->
<!-- <!-- badges: end --> –\>

# astropic

The goal of `astropic` is to connect R to the [NASA APOD
API](https://github.com/nasa/apod-api). The APOD API supports one image
at a time. In order to supply more than that, this package also includes
the option of pulling by date ranges (of less than 2000 days at a time)
and some historical data in tibble format.

Thanks to Michael W. Kearney, author of [rtweet](http://rtweet.info),
for having a robust package based on connecting to an API. I didn’t know
much about APIs when I started this project and looking at his source
code helped a ton!

Credit to the APOD API
[contributors](https://github.com/nasa/apod-api/graphs/contributors) for
all of their work in making the API, and the recent(ish) re-org.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("eringrand/astropic")
```

## API Key

To start, you’ll need a NASA API key. If you do not have one, you can
get one [here](https://api.nasa.gov/index.html#apply-for-an-api-key).

Save this to your environment as `NASA_KEY`. e.g
`Sys.setenv(NASA_KEY = "YOURKEYHERE")`.

## Query

The query parameters are described on the [APOD API Github
page](https://github.com/nasa/apod-api) as such…

- `date` A string in YYYY-MM-DD format indicating the date of the APOD
  image (example: 2014-11-03). Defaults to today’s date. Must be after
  1995-06-16, the first day an APOD picture was posted. There are no
  images for “tomorrow” available through this API.
- `hd` A Boolean parameter indicating whether or not high-resolution
  images should be returned. This is present for legacy purposes, it is
  always ignored by the service and high-resolution urls are returned
  regardless.
- `count` A positive integer, no greater than 100. If this is specified
  then `count` randomly chosen images will be returned in a JSON array.
  Cannot be used in conjunction with `date` or `start_date` and
  `end_date`.
- `start_date` A string in YYYY-MM-DD format indicating the start of a
  date range. All images in the range from `start_date` to `end_date`
  will be returned in a JSON array. Cannot be used with `date`.
- `end_date` A string in YYYY-MM-DD format indicating that end of a date
  range. If `start_date` is specified without an `end_date` then
  `end_date` defaults to the current date.

<!-- - `concept_tags` A Boolean True\|False indicating whether concept tags -->

<!--   should be returned with the rest of the response. The concept tags are -->

<!--   not necessarily included in the explanation, but rather derived from -->

<!--   common search tags that are associated with the description text. -->

<!--   (Better than just pure text search.) Defaults to False. -->

<!-- - `hd` A Boolean True\|False parameter indicating whether or not -->

<!--   high-resolution images should be returned. This is present for legacy -->

<!--   purposes, it is always ignored by the service and high-resolution urls -->

<!--   are returned regardless. -->

<!-- - `count` A positive integer, no greater than 100. If this is specified -->

<!--   then count randomly chosen images will be returned in a JSON array. -->

<!--   Cannot be used in conjunction with date or `start_date` and -->

<!--   `end_date`. -->

<!-- - `start_date` A string in YYYY-MM-DD format indicating the start of a -->

<!--   date range. All images in the range from `start_date` to end_date will -->

<!--   be returned in a JSON array. Cannot be used with date. -->

<!-- - `end_date` A string in YYYY-MM-DD format indicating that end of a date -->

<!--   range. If `start_date` is specified without an `end_date` then -->

<!--   `end_date` defaults to the current date. thumbs A Boolean parameter -->

<!--   True\|False indicating whether the API should return a thumbnail image -->

<!--   URL for video files. If set to True, the API returns URL of video -->

<!--   thumbnail. If an APOD is not a video, this parameter is ignored. -->

### Returned fields

- `date` Date of image. Included in response because of default values.
- `explanation` The supplied text explanation of the image.
- `hdurl` The URL for any high-resolution image for that day. Will be
  omitted in the response IF it does not exist originally at APOD.
- `media_type` The type of media (data) returned. May either be ‘image’
  or ‘video’ depending on content.
- `service_version` The service version used.
- `title` The title of the image.
- `url` The URL of the APOD image or video of the day.
- `copyright` The name of the copyright holder.

## Example

### Basic Example

``` r
library(astropic)
get_apod() # no inputs will get today's image
#> # A tibble: 1 × 7
#>   date       explanation            hdurl media_type service_version title url  
#>   <chr>      <chr>                  <chr> <chr>      <chr>           <chr> <chr>
#> 1 2025-11-17 What has happened to … http… image      v1              Come… http…
```

### Providing a date range

You can also supply a start and end date to get a range of image results
back.

``` r
get_apod(query  = list(start_date = "2018-04-01", end_date = "2018-04-03"))
#> # A tibble: 3 × 8
#>   copyright       date  explanation hdurl media_type service_version title url  
#>   <chr>           <chr> <chr>       <chr> <chr>      <chr>           <chr> <chr>
#> 1 "\nFernando Ca… 2018… I love you… http… image      v1              I Br… http…
#> 2  <NA>           2018… While crui… http… image      v1              Moon… http…
#> 3 "\nSergei Maku… 2018… You may ha… http… image      v1              The … http…
```

### Count - `n` random images

``` r
get_apod(query = list(count = 5))
#> # A tibble: 5 × 8
#>   date       explanation  hdurl media_type service_version title url   copyright
#>   <chr>      <chr>        <chr> <chr>      <chr>           <chr> <chr> <chr>    
#> 1 2020-08-30 How massive… http… image      v1              NGC … http…  <NA>    
#> 2 2023-11-11 This broad,… http… image      v1              The … http… "Julien …
#> 3 2004-10-05 Human space… http… image      v1              Spac… http… "\nScale…
#> 4 2021-12-24 The Crab Ne… http… image      v1              M1: … http… "Michael…
#> 5 2012-04-28 Last Sunday… http… image      v1              Sutt… http…  <NA>
```

### Magic

With a little `magick` you can also save the APOD image to your computer
for use later. This is a demonstration of a picture in APOD I helped to
create!

``` r
library(magick)
library(here)
library(dplyr)

save_image <- function(url){
  image <- try(magick::image_read(url), silent = FALSE)
  image_name <- gsub(".*/([^/]+$)", '\\1', m31$hdurl)
  image_loc <- here::here("man/figures/README", image_name)
  if(class(image)[1] != "try-error"){
    image |>
      magick::image_write(image_loc)
  }
  return(image)
}

m31 <- get_apod(query = list(date = "2009-09-17"))  # only providing a start date will give the image just for that day
dplyr::pull(m31, explanation)
#> [1] "Taken by a telescope onboard NASA's Swift satellite, this stunning vista represents the highest resolution image ever made of the Andromeda Galaxy (aka M31) - at ultraviolet wavelengths. The mosaic is composed of 330 individual images covering a region 200,000 light-years wide. It shows about 20,000 sources, dominated by hot, young stars and dense star clusters that radiate strongly in energetic ultraviolet light. Of course, the Andromeda Galaxy is the closest large spiral galaxy to our own Milky Way, at a distance of some 2.5 million light-years. To compare this gorgeous island universe's appearance in optical light with its ultraviolet portrait, just slide your cursor over the image."
```

    save_image(m31$hdurl)

<img src="man/figures/README-m31-1.png" width="100%" />

## Contact

Come find me on twitter and BlueSky
@[astroeringand](https://twitter.com/astroeringrand)

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
