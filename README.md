
  - [ggcirclepack](#ggcirclepack)
      - [Note to the reader](#note-to-the-reader)
  - [status quo w/o {ggcirclepack}: loads of work before
    plotting](#status-quo-wo-ggcirclepack-loads-of-work-before-plotting)
  - [Proposed UI](#proposed-ui)
  - [Package functions](#package-functions)
      - [geom\_circlepack\_text (center)](#geom_circlepack_text-center)
          - [Step 1. compute panel](#step-1-compute-panel)
          - [Step 1.1 test compute](#step-11-test-compute)
          - [Step 2 and 3 ggproto and
            geom](#step-2-and-3-ggproto-and-geom)
          - [Step 4. test geom](#step-4-test-geom)
      - [geom\_circlepack](#geom_circlepack)
          - [Step 1. compute\_panel](#step-1-compute_panel)
          - [Step 1.1. test compute](#step-11-test-compute-1)
          - [Step 2 & 3 ggproto and geom](#step-2--3-ggproto-and-geom)
          - [Step 4. test geom](#step-4-test-geom-1)
  - [Package the functions](#package-the-functions)
  - [Issues](#issues)
      - [More computation under the hood for a count data
        case.](#more-computation-under-the-hood-for-a-count-data-case)
      - [Quiet the joins.](#quiet-the-joins)
      - [create a ggcirclepack()/defaults\_circlepack() function for
        preferred
        defaults.](#create-a-ggcirclepackdefaults_circlepack-function-for-preferred-defaults)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggcirclepack

<!-- badges: start -->

<!-- badges: end -->

circle pack is an experimental package that uses packcircles to handle
circle packing computation.

### Note to the reader

Your feedback is on this work is greatly appreciated.

Beyond the descriptions of our work, we interject comments on our
hesitations 🤔 and areas that need some work 🚧, for your consideration
marked with emoji.

Your help and feedback would be greatly appreciated on any of the
questions…

  - Are functions named intuitively? *‘According to IBM studies,
    intuitive variable naming contributes more to code readability than
    comments, or for that matter, any other factor’ McConnell, S. Code
    complete*
  - Do functions work as you expect?
  - Is there rewriting that could make the code more concise?
  - What tests should be performed?

# status quo w/o {ggcirclepack}: loads of work before plotting

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.0     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.1     ✔ tibble    3.2.0
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
gapminder::gapminder %>%  
  filter(continent == "Americas") %>%  
  filter(year == 2002) %>%  
  select(country, pop) %>% 
  mutate(id = row_number()) ->  
df_w_id

packcircles::circleProgressiveLayout(df_w_id$pop,  
                                         sizetype = 'area') ->  
x0y0radius  

x0y0radius %>%  
  packcircles::circleLayoutVertices(npoints = 50) ->  
circle_outlines  

circle_outlines %>% 
  left_join(df_w_id) %>% 
  ggplot() +  
  aes(x = x, y = y) +  
  geom_polygon(colour = "black", alpha = 0.6) +  
  aes(group = id) +  
  aes(fill = pop) +  
  geom_text(data = cbind(df_w_id, x0y0radius),  
            aes(x, y, size = pop, label = country,  
                group = NULL, fill = NULL)) +  
  theme(legend.position = "none") +  
  coord_equal()
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

# Proposed UI

``` r
library(tidyverse)
library(ggcirclepack)

gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country, area = pop) +
  geom_circlepack() +               # draws packed circles 
  geom_circlepack_text() +          # labels at the center
  coord_fixed(ratio = 1)
```

# Package functions

## geom\_circlepack\_text (center)

### Step 1. compute panel

``` r
#' compute_panel_circlepack_center
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
compute_panel_circlepack_center <- function(data, scales){

  data ->
    data1

  if(is.null(data$area)){

    data1 %>%
      mutate(area = 1) ->
      data1

  }

  data1 %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    cbind(data1) %>%
    mutate(label = id)

}
```

### Step 1.1 test compute

``` r
gapminder::gapminder %>%
filter(continent == "Americas") %>%
  filter(year == 2002) %>%
  # input must have required aesthetic inputs as columns
  select(area = pop, id = country) %>%
  compute_panel_circlepack_center() %>%
  head()
#>           x         y   radius      area        id     label
#> 1 -3493.018     0.000 3493.018  38331121 Argentina Argentina
#> 2  1639.564     0.000 1639.564   8445134   Bolivia   Bolivia
#> 3  2732.774 -9142.026 7567.594 179914212    Brazil    Brazil
#> 4  1150.752  4801.407 3186.661  31902268    Canada    Canada
#> 5  5273.817  1302.381 2221.005  15497046     Chile     Chile
#> 6 10562.330 -1160.651 3612.938  41008227  Colombia  Colombia
```

### Step 2 and 3 ggproto and geom

``` r
StatCirclepackcenter <- ggplot2::ggproto(`_class` = "StatCirclepackcenter",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id"),
                                  compute_panel = compute_panel_circlepack_center,
                                  default_aes = ggplot2::aes(group = after_stat(id),
                                                             size = after_stat(area))
                                  )


#' Title
#'
#' @param mapping
#' @param data
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
geom_circlepack_text <- function(mapping = NULL, data = NULL,
                           position = "identity", na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatCirclepackcenter, # proto object from Step 2
    geom = ggplot2::GeomText, # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
```

### Step 4. test geom

``` r
gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country, area = pop) +
  geom_circlepack_text(alpha = .5) + 
  coord_equal() + 
  labs(title = "gapminder 2002 countries")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

## geom\_circlepack

### Step 1. compute\_panel

``` r
# Step 1
#' compute_panel_circlepack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' TBD
compute_panel_circlepack <- function(data, scales){

  data %>%
    mutate(id = row_number()) ->
    data1

  if(is.null(data$area)){

    data1 %>%
      mutate(area = 1) ->
      data1

  }

  data1 %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    packcircles::circleLayoutVertices(npoints = 50) %>%
    left_join(data1) #%>%

}
```

### Step 1.1. test compute

``` r
gapminder::gapminder %>%
filter(continent == "Americas") %>%
  filter(year == 2002) %>%
  # input must have required aesthetic inputs as columns
  rename(area = pop) %>%
  compute_panel_circlepack() %>%
  head()
#> Joining with `by = join_by(id)`
#>            x         y id   country continent year lifeExp     area gdpPercap
#> 1    0.00000    0.0000  1 Argentina  Americas 2002   74.34 38331121  8797.641
#> 2  -27.54349  437.7912  1 Argentina  Americas 2002   74.34 38331121  8797.641
#> 3 -109.73958  868.6783  1 Argentina  Americas 2002   74.34 38331121  8797.641
#> 4 -245.29200 1285.8657  1 Argentina  Americas 2002   74.34 38331121  8797.641
#> 5 -432.06299 1682.7743  1 Argentina  Americas 2002   74.34 38331121  8797.641
#> 6 -667.10708 2053.1445  1 Argentina  Americas 2002   74.34 38331121  8797.641
```

### Step 2 & 3 ggproto and geom

``` r
StatCirclepack <- ggplot2::ggproto(`_class` = "StatCirclepack",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id"),
                                  compute_panel = compute_panel_circlepack,
                                  default_aes = ggplot2::aes(group = after_stat(id))
                                  )

#' Title
#'
#' @param mapping
#' @param data
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
geom_circlepack <- function(mapping = NULL, data = NULL,
                           position = "identity", na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatCirclepack, # proto object from Step 2
    geom = ggplot2::GeomPolygon, # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
```

### Step 4. test geom

``` r


gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country) +
  geom_circlepack(alpha = .5) + 
  coord_equal() + 
  labs(title = "gapminder 2002 countries")
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r

last_plot() +
  aes(fill = continent) + 
  labs(title = "from 5 continents")
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-2.png" width="100%" />

``` r

last_plot() +
  aes(area = pop) + 
  geom_circlepack_text() + 
  labs(title = "with very different populations")
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-3.png" width="100%" />

``` r

last_plot() +
  facet_wrap(facets = vars(continent)) + 
  labs(title = "faceting")
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-4.png" width="100%" />

``` r

last_plot() + 
  scale_size_continuous(range = c(0, 4)) + 
  theme(legend.position = "none") + 
  labs(title = "remove legends")
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-5.png" width="100%" />

``` r

last_plot() + 
  aes(area = gdpPercap*pop) + 
  labs(title = "and very different GDPs")
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-6.png" width="100%" />

``` r

last_plot() + 
  aes(area = gdpPercap) + 
  labs(title = "and per capita GDPs")
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-7.png" width="100%" />

``` r


gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country) +
  geom_circlepack(alpha = .5) + 
  coord_equal() +
  aes(area = pop) + 
  geom_circlepack_text(aes(label = after_stat(
    paste(id, "\n",
    round(area/1000000, 1), "mil."))), lineheight = .8)
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-6-8.png" width="100%" />

# Package the functions

``` r
readme2pkg::chunk_to_r(chunk_name = "compute_panel_circlepack")
readme2pkg::chunk_to_r(chunk_name = "geom_circlepack")
readme2pkg::chunk_to_r(chunk_name = "compute_panel_circlepack_center")
readme2pkg::chunk_to_r(chunk_name = "geom_circlepack_text")
```

# Issues

Wish list for ggcirclepack:

## More computation under the hood for a count data case.

``` r
tidytitanic::tidy_titanic %>% 
  head()
#>   id class  sex   age survived
#> 1  1   3rd Male Child       No
#> 2  2   3rd Male Child       No
#> 3  3   3rd Male Child       No
#> 4  4   3rd Male Child       No
#> 5  5   3rd Male Child       No
#> 6  6   3rd Male Child       No
```

    tidytitanic::tidy_titanic() + 
      ggplot() + 
      aes(id = "all") + 
      geom_circlepack(alpha = .5) + 
      geom_circlepack_text(aes(label = afterstat(count))) + # automatically labels with count
      aes(linetype = sex) + 
      aes(color = age) + 
      aes(alpha = survived) + 
      facet_wrap(~class)

## Quiet the joins.

## create a ggcirclepack()/defaults\_circlepack() function for preferred defaults.
