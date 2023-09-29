
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggcirclepack

<!-- badges: start -->

<!-- badges: end -->

circle pack is an experimental package that uses packcircles to handle
circle packing computation.

# status quo w/o {ggcirclepack}: loads of work before plotting

``` r
gapminder::gapminder %>%  
  filter(continent == "Americas") %>%  
  filter(year == 2002) %>%  
  select(country, pop) ->  
prep  

packcircles::circleProgressiveLayout(prep$pop,  
                                         sizetype = 'area') ->  
pack  

pack %>%  
  packcircles::circleLayoutVertices(npoints = 50) ->  
circle_outlines  

circle_outlines %>%  
  ggplot() +  
  aes(x = x, y = y) +  
  geom_polygon(colour = "black", alpha = 0.6) +  
  aes(group = id) +  
  aes(fill = factor(id)) +  
  geom_text(data = cbind(prep, pack),  
            aes(x, y, size = pop, label = country,  
                group = NULL, fill = NULL)) +  
  theme(legend.position = "none") +  
  coord_equal()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Proposed UI and current behavior

``` r
library(ggcirclepack)
library(tidyverse)

gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country) +
  geom_polygon_circlepack(alpha = .5) + 
  coord_equal() + 
  labs(title = "gapminder 2002 countries")

last_plot() +
  aes(fill = continent) + 
  labs(title = "from 5 continents")

last_plot() +
  aes(area = pop) + 
  geom_text_circlepack() + 
  labs(title = "with very different populations")

last_plot() +
  facet_wrap(facets = vars(continent)) + 
  labs(title = "faceting")

last_plot() + 
  scale_size_continuous(range = c(0, 4)) + 
  theme(legend.position = "none") + 
  labs(title = "remove legends")

last_plot() + 
  aes(area = gdpPercap*pop) + 
  labs(title = "and very different GDPs")

last_plot() + 
  aes(area = gdpPercap) + 
  labs(title = "and per capita GDPs")
```

<img src="man/figures/README-example-1.png" width="33%" /><img src="man/figures/README-example-2.png" width="33%" /><img src="man/figures/README-example-3.png" width="33%" /><img src="man/figures/README-example-4.png" width="33%" /><img src="man/figures/README-example-5.png" width="33%" /><img src="man/figures/README-example-6.png" width="33%" /><img src="man/figures/README-example-7.png" width="33%" />

``` r
gapminder::gapminder %>%
filter(year == 2002) %>%
  ggplot() +
  aes(id = country) +
  geom_polygon_circlepack(alpha = .5) + 
  coord_equal() +
  aes(area = pop) + 
  geom_text_circlepack(aes(label = after_stat(
    paste(id, "\n",
    round(area/1000000, 1), "mil."))), lineheight = .8)
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

# Package functions

## geom\_circle\_pack

``` r
#' compute_panel_circle_pack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(magrittr)
#' library(dplyr)
#' gapminder::gapminder %>%
#' filter(continent == "Americas") %>%
#'   filter(year == 2002) %>%
#'   # input must have required aesthetic inputs as columns
#'   rename(area = pop) %>%
#'   compute_panel_circle_pack() %>%
#'   head()
#'
#'   gapminder::gapminder %>%
#' filter(continent == "Americas") %>%
#'  filter(year == 2002) %>%
#'  # input must have required aesthetic inputs as columns
#'  rename(area = pop) %>%
#'  compute_panel_circle_pack() %>%
#'  ggplot() +
#'  aes(x = x, y = y, fill = country) +
#'  geom_polygon()
compute_panel_circle_pack <- function(data, scales){

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
    packcircles::circleLayoutVertices(npoints = 300) %>%
    left_join(data1) #%>%

}


StatCirclepack <- ggplot2::ggproto(`_class` = "StatCirclepack",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id"),
                                  compute_panel = compute_panel_circle_pack,
                                  # setup_data = my_setup_data,
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
#' library(ggplot2)
#' library(magrittr)
#' library(dplyr)
#' gapminder::gapminder %>%
#' filter(year == 2002) %>%
#'   ggplot() +
#'   aes(id = country) +
#'   geom_polygon_circlepack(alpha = .5, size = .002)
#'
#' last_plot() +
#'   aes(fill = continent)
#'
#' last_plot() +
#'   aes(area = pop)
#'
#' last_plot() +
#'   aes(color = continent) +
#'   facet_wrap(facets = vars(continent))
geom_polygon_circlepack <- function(mapping = NULL, data = NULL,
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

## geom\_text\_circlepack

``` r
#' compute_panel_circle_pack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(magrittr)
#' library(dplyr)
#' gapminder::gapminder %>%
#' filter(continent == "Americas") %>%
#'   filter(year == 2002) %>%
#'   # input must have required aesthetic inputs as columns
#'   rename(area = pop) %>%
#'   compute_panel_circle_pack() %>%
#'   head()
#'
#'  gapminder::gapminder %>%
#'    filter(continent == "Americas") %>%
#'  filter(year == 2002) %>%
#'  # input must have required aesthetic inputs as columns
#'  rename(area = pop) %>%
#'  compute_panel_circle_pack() %>%
#'  ggplot() +
#'  aes(x = x, y = y, fill = country) +
#'  geom_polygon()
compute_panel_circle_pack_center <- function(data, scales){

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




StatCirclepackcenter <- ggplot2::ggproto(`_class` = "StatCirclepackcenter",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id"),
                                  compute_panel = compute_panel_circle_pack_center,
                                  # setup_data = my_setup_data,
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
#' library(ggplot2)
#' library(magrittr)
#' library(dplyr)
#' gapminder::gapminder %>%
#' filter(year == 2002) %>%
#'   ggplot() +
#'   aes(id = country) +
#'   geom_text_circlepack(alpha = .5)
#'
#' last_plot() +
#'   aes(fill = continent)
#'
#' last_plot() +
#'   aes(area = pop)
#'
#' last_plot() +
#'   facet_wrap(facets = vars(continent))
geom_text_circlepack <- function(mapping = NULL, data = NULL,
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

``` r
readme2pkg::chunk_to_r(c("geom_circle_pack","geom_circle_pack_text"))
```

### Issues

Wish list for ggcirclepack: More computation under the hood for a count
data case.

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
      aes(x = "all") + 
      geom_polygon_circlepack(alpha = .5) + 
      geom_text_circlepack(aes(label = afterstat(count))) + # automatically labels with count
      aes(linetype = sex) + 
      aes(color = age) + 
      aes(alpha = survived) + 
      facet_wrap(~class)
