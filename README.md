
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![codecov](https://codecov.io/gh/eringrand/astropic/graph/badge.svg?token=5HHWM5HDHE)](https://codecov.io/gh/eringrand/astropic)
[![R-CMD-check](https://github.com/EvalResearchAtTRAILS/trails_r_packge_tbd/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/eringrand/astropic/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

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
#>         date
#> 1 2025-11-18
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            explanation
#> 1 What does the Milky Way look like in radio waves? To better find out, GLEAM surveyed the central band of our galaxy in high resolution radio light as imaged by the Murchison Widefield Array in Australia.  As the featured video slowly scrolls, radio light (71 - 231 MHz) is seen on the left and visible light -- from the same field -- on the right. Differences are so great because most objects glow differently in radio and visible light, and because visible light is stopped by nearby interstellar dust. These differences are particularly apparent in the direction toward the center of our galaxy, seen about a third of the way through.  Among the many features that appear in the radio, bright red patches are usually supernova remnants of exploded stars, while areas colored blue are stellar nurseries filled with bright young stars.    Did you know: APOD is available from numerous sites, including social media?
#>   media_type service_version                                    title
#> 1      other              v1 The Galactic Plane: Radio Versus Visible
```

### Providing a date range

You can also supply a start and end date to get a range of image results
back.

``` r
get_apod(query  = list(start_date = "2018-04-01", end_date = "2018-04-03"))
#>                copyright       date
#> 1 \nFernando Cabrerizo\n 2018-04-01
#> 2                   <NA> 2018-04-02
#> 3     \nSergei Makurin\n 2018-04-03
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 explanation
#> 1                                                                                                                                                                                                                                I love you so much that I brought you the Moon.  Please take it before this tree becomes more interested.  Also, the Moon is heavier than I thought.  And I foolishly picked it up by the hot side by mistake.  But it is for you and, well, the others reading this APOD.  Promise to keep this image -- our image -- in a safe place, and know that it was taken in a single, well-planned exposure in Valladolid, Spain.  Please take it and keep it always as a token of our love and, well, April Fool's Day.   Retrospective: April Fool's Day APODs
#> 2                                                                While cruising around Saturn, be on the lookout for picturesque juxtapositions of moons, rings, and shadows. One quite picturesque arrangement occurred in 2005 and was captured by the then Saturn-orbiting Cassini spacecraft. In the featured image, moons Tethys and Mimas are visible on either side of Saturn's thin rings, which are seen nearly edge-on.  Across the top of Saturn are dark shadows of the wide rings, exhibiting their impressive complexity. The violet-light image brings up the texture of the backdrop: Saturn's clouds. Cassini orbited Saturn from 2004 until September of last year, when the robotic spacecraft was directed to dive into Saturn to keep it from contaminating any moons.
#> 3 You may have heard of the Seven Sisters in the sky, but have you heard about the Seven Strong Men on the ground? Located just west of the Ural Mountains, the unusual Manpupuner rock formations are one of the Seven Wonders of Russia. How these ancient 40-meter high pillars formed is yet unknown.  The persistent photographer of this featured image battled rough terrain and uncooperative weather to capture these rugged stone towers in winter at night, being finally successful in February of 2014.  Utilizing the camera's time delay feature, the photographer holds a flashlight in the foreground near one of the snow-covered pillars.  High above, millions of stars shine down, while the band of our Milky Way Galaxy crosses diagonally down from the upper left.
#>                                                                    hdurl
#> 1      https://apod.nasa.gov/apod/image/1804/Moon4You_Cabreriza_1800.jpg
#> 2 https://apod.nasa.gov/apod/image/1804/SaturnRingsMoons_Cassini_967.jpg
#> 3   https://apod.nasa.gov/apod/image/1804/SevenStrongSky_Makurin_960.jpg
#>   media_type service_version
#> 1      image              v1
#> 2      image              v1
#> 3      image              v1
#>                                                     title
#> 1                                  I Brought You the Moon
#> 2         Moons, Rings, Shadows, Clouds: Saturn (Cassini)
#> 3 The Milky Way over the Seven Strong Men Rock Formations
#>                                                                      url
#> 1      https://apod.nasa.gov/apod/image/1804/Moon4You_Cabreriza_1080.jpg
#> 2 https://apod.nasa.gov/apod/image/1804/SaturnRingsMoons_Cassini_967.jpg
#> 3   https://apod.nasa.gov/apod/image/1804/SevenStrongSky_Makurin_960.jpg
```

### Count - `n` random images

``` r
get_apod(query = list(count = 5))
#>         copyright       date
#> 1    Ken Crawford 2013-10-09
#> 2  Babak Tafreshi 2013-03-14
#> 3            <NA> 1997-04-05
#> 4            <NA> 2011-08-26
#> 5 \nBrad Hannon\n 2023-11-29
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  explanation
#> 1                                                                                                                                                                                                                                                                                                            This telescopic snapshot records a cosmic moment in the tumultuous lives of large spiral galaxy NGC 3227 and smaller elliptical NGC 3226. Catching them in the middle of an ongoing gravitational dance, the sensitive imaging also follows faint tidal star streams flung from the galaxies in their repeated close encounters. Over 50 million light-years distant toward the constellation Leo, the pair's appearance has earned them the designation Arp 94 in the classic catalog of peculiar galaxies. But such galactic collisions and mergers are now thought to represent a normal course in the evolution of galaxies, including our own Milky Way. Spanning about 90,000 light-years, similar in size to the Milky Way, NGC 3227 is recognized as an active Seyfert galaxy with a central supermassive black hole.   Note: How to find APOD Alternative Mirror Sites
#> 2                                                                                                                                                                                                                                                                                                                                                                                                           In silhouette against the colorful evening twilight, clouds part for this much anticipated magic moment. The scene captures naked-eye Comet PanSTARRS peeking into northern hemisphere skies on March 12. The comet stands over the western horizon after sunset, joined by the thin, flattened crescent of a day old Moon. Posing for its own beauty shot, the subtly lit dome of the 4.2 meter William Herschel Telescope is perched above cloud banks on the Canary Island of La Palma. While PanSTARRS has not quite developed into the spectacular comet once hoped for, it is still growing easier to see in the north. In coming days it will steadily climb north, farther from the Sun into darker western evening skies.   Growing Gallery:  Comet PanSTARRS at Sunset
#> 3                                                                                                                                                                                                                                                                                                                                                                         The center of nearby giant galaxy M87 is a dense and violent place. In this 1994 photograph by the Hubble Space Telescope, a disk of hot gas was found to be orbiting at the center of this massive elliptical galaxy. The disk is evident at the lower left of the picture. The rotation speed of gas in this disk indicates the mass of the object the gas is orbiting, while the size of the disk indicates an approximate volume of the central object. These observations yield a central density so high that the only hypothesized object that could live there is a black hole. The picture also shows a highly energetic jet emanating from the central object like a cosmic blowtorch. The jet is composed of fast moving charged particles and has broken into knots as small as 10 light years across.
#> 4 A nearby star has exploded and telescopes all over the world are turning to monitor it.  The supernova, dubbed PTF 11kly, was discovered by computer only two days ago as part of the Palomar Transient Factory (PTF) sky survey utilizing the wide angle 1.2-meter Samuel Oschin Telescope in California.  Its rapid recovery makes it one of the supernovas caught most soon after ignition.  PTF 11kly occurred in the photogenic Pinwheel galaxy (M101), which, being only about 21 million light years away, makes it one of the closest supernovas seen in decades.  Rapid follow up observations have already given a clear indication that PTF 11kly is a Type Ia supernova, a type of white dwarf detonation that usually progresses in such a standard manner than it has helped to calibrate the expansion history of the entire universe.  Studying such a close and young Type Ia event, however, may yield new and unique clues. If early indications are correct, PTF 11kly should brighten to about visual magnitude 10 in the coming weeks, making it possible to monitor with even moderately sized telescopes.   APOD Retrospective: The best of the spiral galaxy M101
#> 5                                                                                                                                                                                                                                                                                                                                                                    Could there be a tornado inside another tornado? In general, no.  OK, but could there be a tornado inside a wider dust devil? No again, for one reason because tornados comes down from the sky, but dust devils rise up from the ground. What is pictured is a landspout, an unusual type of tornado known to occur on the edge of a violent thunderstorm. The featured landspout was imaged and identified in Kansas, USA, in June 2019 by an experienced storm chaser.  The real tornado is in the center, and the outer sheath was possibly created by large dust particles thrown out from the central tornado. So far, the only planet known to create tornados is Earth, although tornado-like activity has been found on the Sun and dust devils are common on Mars.   Almost Hyperspace: Random APOD Generator
#>                                                                             hdurl
#> 1                      https://apod.nasa.gov/apod/image/1310/NGC3227_crawford.jpg
#> 2 https://apod.nasa.gov/apod/image/1303/PanStarrsMoon-LaPalma-BabakTafreshi-s.jpg
#> 3                           https://apod.nasa.gov/apod/image/9704/m87_hst_big.jpg
#> 4                  https://apod.nasa.gov/apod/image/1108/ptf11kly_howell_1524.jpg
#> 5             https://apod.nasa.gov/apod/image/2311/LowerLandspout_Hannon_960.jpg
#>   media_type service_version                                           title
#> 1      image              v1                                          Arp 94
#> 2      image              v1                 Clouds, Comet and Crescent Moon
#> 3      image              v1                 A Black Hole in M87?\r\nCredit:
#> 4      image              v1 A Young Supernova in the Nearby Pinwheel Galaxy
#> 5      image              v1                 A Landspout Tornado over Kansas
#>                                                                                  url
#> 1                      https://apod.nasa.gov/apod/image/1310/NGC3227_crawford950.jpg
#> 2 https://apod.nasa.gov/apod/image/1303/PanStarrsMoon-LaPalma-BabakTafreshi-s900.jpg
#> 3                                  https://apod.nasa.gov/apod/image/9704/m87_hst.jpg
#> 4                      https://apod.nasa.gov/apod/image/1108/ptf11kly_howell_900.jpg
#> 5                https://apod.nasa.gov/apod/image/2311/LowerLandspout_Hannon_960.jpg
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

## Contact

Come find me on BlueSky
@[@astroeringrand.bsky.social](https://bsky.app/profile/astroeringrand.bsky.social)

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
