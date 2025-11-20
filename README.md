
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![codecov](https://codecov.io/gh/eringrand/astropic/graph/badge.svg?token=5HHWM5HDHE)](https://codecov.io/gh/eringrand/astropic)
[![R-CMD-check.yaml](https://github.com/eringrand/astropic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/eringrand/astropic/actions/workflows/R-CMD-check.yaml)

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
#>        copyright       date
#> 1 Aygen Erkaslan 2025-11-20
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           explanation
#> 1 Alnitak, Alnilam, and Mintaka are the bright bluish stars from east to west (upper right to lower left) along the diagonal in this cosmic vista. Otherwise known as the Belt of Orion, these three blue supergiant stars are hotter and much more massive than the Sun. They lie from 700 to 2,000 light-years away, born of Orion's well-studied interstellar clouds. In fact, clouds of gas and dust adrift in this region have some surprisingly familiar shapes, including the dark Horsehead Nebula and Flame Nebula near Alnitak at the upper right. The famous Orion Nebula itself is off the right edge of this colorful starfield. The telescopic frame spans almost 4 degrees on the sky.
#>                                                                     hdurl
#> 1 https://apod.nasa.gov/apod/image/2511/NebularSymphonyOrionsBelt2048.jpg
#>   media_type service_version                     title
#> 1      image              v1 Alnitak, Alnilam, Mintaka
#>                                                                       url
#> 1 https://apod.nasa.gov/apod/image/2511/NebularSymphonyOrionsBelt1024.jpg
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
#>         date
#> 1 2000-12-04
#> 2 2002-04-12
#> 3 2018-02-21
#> 4 1997-06-06
#> 5 2017-04-10
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     explanation
#> 1                                                                                                                                                                                                                                                                                                                                       Powerful forces are at play in the nearby Circinus Galaxy.  Hot gas, colored pink, is being ejected out of the spiral galaxy from the central region.  Much of Circinus' tumultuous gas, however, is concentrated in two rings.  The outer ring, located about 700 light-years from the center, appears mostly red and is home to tremendous bursts of star formation.  A previously unseen inner ring, inside the green disk above, is visible only 130 light years from the center on this recently released, representative color image taken by the Hubble Space Telescope.  At the very center is an active galactic nucleus, where matter glows brightly before likely spiraling into a massive black hole.  Although only 15 million light years distant, the Circinus Galaxy went unnoticed until 25 years ago because it is so obscured by material in the plane of our own Galaxy.  The galaxy can be seen with a small telescope, however, in the constellation of Circinus.
#> 2                                                    This gorgeous galaxy and comet portrait was recorded on April 5th in the skies over the Oriental Pyrenees near Figueres, Spain. From a site above 1,100 meters, astrophotographer Juan Carlos Casado used a guided time exposure, fast film, and a telephoto lens to capture the predicted conjunction of the bright Comet Ikeya-Zhang (right) and the Andromeda Galaxy (left). This stunning celestial scene would also have been a rewarding one for the influential 18th century comet hunter Charles Messier. While Messier scanned French skies for comets, he carefully cataloged positions of things which were fuzzy and comet-like in appearance but did not move against the background stars and so were definitely not comets. The Andromeda Galaxy, also known as M31, is the 31st object in his famous not-a-comet catalog. Not-a-comet object number 110, a late addition to Messier's catalog, is one of Andromeda's small satellite galaxies, and can be seen here just below M31. Our modern understanding holds that the Andromeda galaxy is a large spiral galaxy some 2 million light-years distant. The photogenic Comet Ikeya-Zhang, now a lovely sight in early morning skies, is about 80 million kilometers (4 light-minutes) from planet Earth.
#> 3 Jupiter looks a bit different in infrared light. To better understand Jupiter's cloud motions and to help NASA's robotic Juno spacecraft understand the planetary context of the small fields that it sees, the Hubble Space Telescope is being directed to regularly image the entire Jovian giant. The colors of Jupiter being monitored go beyond the normal human visual range to include both ultraviolet and infrared light.  Featured here in 2016, three bands of near-infrared light have been digitally reassigned into a mapped color image.  Jupiter appears different in infrared partly because the amount of sunlight reflected back is distinct, giving differing cloud heights and latitudes discrepant brightnesses. Nevertheless, many familiar features on Jupiter remain, including the  light zones and dark belts that circle the planet near the equator, the Great Red Spot on the lower left, and the string-of-pearls storm systems south of the Great Red Spot.  The poles glow because high altitude haze there is energized by charged particles from Jupiter's magnetosphere.  Juno has now completed 10 of 12 planned science orbits of Jupiter and continues to record data that are helping humanity to understand not only Jupiter's weather but what lies beneath Jupiter's thick clouds.
#> 4                                                                                                                                                                                                                                                             ven great observatories need a boost from time to time -- including the orbiting Compton Gamma-Ray Observatory. Sparkling reflections and the bright limb of the Earth are visible in this 1991 window view of Compton's release into orbit by the crew of the Space Shuttle Atlantis. Named after the American Nobel-prize-winning physicist, Arthur Holly Compton, the Compton Observatory has spent the last 6 years making spectacular discoveries while exploring the Universe at extreme gamma-ray energies. From its post over 240 miles above the Earth's surface, the 17 ton satellite still experiences enough atmospheric drag to cause its orbit to deteriorate over time.  But NASA controllers have just completed a complex two month long series of firings of Compton's on-board thrusters which has raised its orbit to an altitude of over 300 miles. This reboost (Compton's second in 6 years) should allow it to continue its voyage of exploration of the distant high-energy Universe until about 2007. What if you could see gamma rays?
#> 5                                                                                                                                                                                                  Why would this cluster of galaxy punch a hole in the cosmic microwave background (CMB)? First, the famous CMB was created by cooling gas in the early universe and flies right through most gas and dust in the universe. It is all around us. Large clusters of galaxies have enough gravity to contain very hot gas -- gas hot enough to up-scatter microwave photons into light of significantly higher energy, thereby creating a hole in CMB maps.  This Sunyaev�Zel'dovich (SZ) effect has been used for decades to reveal new information about hot gas in clusters and even to help discover galaxy clusters in a simple yet uniform way. Pictured is the most detailed image yet obtained of the SZ effect, now using both  ALMA to measure the CMB and the Hubble Space Telescope to measure the galaxies in the massive galaxy cluster RX J1347.5-1145.  False-color blue depicts light from the CMB, while almost every yellow object is a galaxy.  The shape of the SZ hole indicates not only that hot gas is present in this galaxy cluster, but also that it is distributed in a surprisingly uneven manner.
#>                                                                      hdurl
#> 1               https://apod.nasa.gov/apod/image/0012/circinus_hst_big.jpg
#> 2             https://apod.nasa.gov/apod/image/0204/ikeya-zhang_casado.jpg
#> 3   https://apod.nasa.gov/apod/image/1802/JupiterIR_HubbleSchmidt_1211.jpg
#> 4                  https://apod.nasa.gov/apod/image/9706/gro8_st37_big.jpg
#> 5 https://apod.nasa.gov/apod/image/1704/GalaxyClusterSZ_AlmaHubble_800.jpg
#>   media_type service_version
#> 1      image              v1
#> 2      image              v1
#> 3      image              v1
#> 4      image              v1
#> 5      image              v1
#>                                                     title
#> 1                                     The Circinus Galaxy
#> 2                                 A Galaxy is not a Comet
#> 3                         Jupiter in Infrared from Hubble
#> 4                               Boosting Compton\nCredit:
#> 5 Galaxy Cluster Gas Creates Hole in Microwave Background
#>                                                                        url
#> 1                   https://apod.nasa.gov/apod/image/0012/circinus_hst.jpg
#> 2          https://apod.nasa.gov/apod/image/0204/ikeya-zhang_casado_c1.jpg
#> 3    https://apod.nasa.gov/apod/image/1802/JupiterIR_HubbleSchmidt_960.jpg
#> 4                      https://apod.nasa.gov/apod/image/9706/gro8_st37.jpg
#> 5 https://apod.nasa.gov/apod/image/1704/GalaxyClusterSZ_AlmaHubble_960.jpg
#>                copyright
#> 1                   <NA>
#> 2 \nJuan Carlos Casado\n
#> 3                   <NA>
#> 4                   <NA>
#> 5                   <NA>
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
