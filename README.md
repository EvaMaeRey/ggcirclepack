
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggcirclepack and beyond - highly experimental

<!-- badges: start -->

<!-- badges: end -->

Critical moment in my extension journey started with TLP.

Message 1: you can be an extender

–

Message 2: “where” aesthetics need not only be x and y.

–

aes(x0 = ?, y0 = ?)

–

And what ggplot2 actually looks at is computed for you (x and y)

-----

Today I’ll present on ggcirclepack.

-----

Background: ggplot2 grammar guide walk through (reference from data to
viz gallery)

–

This didn’t feel like powerful ggplot2 experience

–

But what if it could?

-----

Here, the id of the circle isn’t defined by the center, but by it’s id…

–

Working with compute\_panel(), ggols

-----

## Installation

You can install the development version of ggcirclepack from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EvaMaeRey/ggcirclepack")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ggcirclepack)
library(ggplot2)
library(magrittr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country) +
  geom_polygon_circlepack(alpha = .5) + 
  coord_equal()
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

last_plot() +
  aes(fill = continent) + 
  labs(title = "gapminder 2002 countries")
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-2.png" width="100%" />

``` r

last_plot() +
  aes(area = pop)
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-3.png" width="100%" />

``` r

last_plot() +
  facet_wrap(facets = vars(continent)) + 
  geom_text_circlepack()
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-4.png" width="100%" />

``` r


last_plot() + 
  scale_size_continuous(range = c(0, 4)) + 
  theme(legend.position = "none")
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-5.png" width="100%" />

``` r

last_plot() + 
  aes(area = gdpPercap*pop)
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-6.png" width="100%" />

``` r

last_plot() + 
  aes(area = gdpPercap)
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-7.png" width="100%" />

-----

Wish list for ggcirclepack:

More computation under the hood for a count data case.

``` r
tidytitanic::tidy_titanic %>% 
  head()
#> # A tibble: 6 × 5
#>      id class sex   age   survived
#>   <int> <fct> <fct> <fct> <fct>   
#> 1     1 3rd   Male  Child No      
#> 2     2 3rd   Male  Child No      
#> 3     3 3rd   Male  Child No      
#> 4     4 3rd   Male  Child No      
#> 5     5 3rd   Male  Child No      
#> 6     6 3rd   Male  Child No
```

    tidytitanic::tidy_titanic() + 
      ggplot() + 
      aes(x = "all") + 
      geom_polygon_circlepack(alpha = .5) + 
      geom_text_circlepack(aes(label = afterstat(count))) + # automatically labels with count
      aes(linetype = sex) + 
      aes(color = age) + 
      aes(alpha = survived) + 
      facet_wrap(~class)

-----

Include other circlepacking algorithms.

–

get feedback from pack circles author\!

-----

### Extremely highly experimental: maps and atlasses.

–

## aes(where = ?)

aes(country = ?)

aes(state = ?)

aes(fips = ?) \# us county codes

aes(brain\_segment = ?)

aes(tissue = ?)

–
