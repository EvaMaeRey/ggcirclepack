
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggcirclepack and beyond - highly experimental

<!-- badges: start -->

<!-- badges: end -->

Critical moment in my extension journey started with TLP “extend your
ability to extend”.

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

``` r
knitr::include_url("https://evamaerey.github.io/ggplot2_grammar_guide/geoms_single_series.html#77")
```

<iframe src="https://evamaerey.github.io/ggplot2_grammar_guide/geoms_single_series.html#77" width="100%" height="400px" data-external="1">

</iframe>

–

This didn’t feel like powerful ggplot2 experience

–

What would ggcirclepack look like?

-----

Here, the id of the circle isn’t defined by the center, x0y0, but by its
id and area (an algorithm used under the hood to find x0y0 and x and y
for perimeter)

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
  aes(area = pop) + 
  geom_text_circlepack()
#> Joining with `by = join_by(id)`
```

<img src="man/figures/README-example-3.png" width="100%" />

``` r

last_plot() +
  facet_wrap(facets = vars(continent))
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

Other wish list item.. Include other circlepacking algorithms.

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

-----

# U.S. States

  - inheriting from geom\_polygon
  - ‘computing’ state xy perimeter based aes = my\_state\_var
  - Ryan Miller tutorial start point.

<!-- end list -->

``` r
knitr::include_url("https://evamaerey.github.io/mytidytuesday/2022-11-04-brain/brain.html")
```

<iframe src="https://evamaerey.github.io/mytidytuesday/2022-11-04-brain/brain.html" width="100%" height="400px" data-external="1">

</iframe>

-----

``` r
knitr::include_url("https://evamaerey.github.io/mytidytuesday/2023-03-06-us-states/us_states.html")
```

<iframe src="https://evamaerey.github.io/mytidytuesday/2023-03-06-us-states/us_states.html" width="100%" height="400px" data-external="1">

</iframe>

-----

# U.S. counties

  - inheriting from geom\_sf()
  - ‘computing’ fips sf geometries column (xy perimeters) based on aes =
    my\_fips\_code
  - Wilke example start point

<!-- end list -->

``` r
knitr::include_url("https://evamaerey.github.io/mytidytuesday/2023-03-10-ggfips/ggfips_w_sf.html")
```

<iframe src="https://evamaerey.github.io/mytidytuesday/2023-03-10-ggfips/ggfips_w_sf.html" width="100%" height="400px" data-external="1">

</iframe>

-----

# Brain seg

  - inheriting from geom\_sf()
  - ‘computing’ tissue space based on aes = my\_seg\_name variable
  - atlases from ggseg

<!-- end list -->

``` r
knitr::include_url("https://evamaerey.github.io/mytidytuesday/2023-03-12-ggbrain-seg-sf/ggbrain_seg_sf.html")
```

<iframe src="https://evamaerey.github.io/mytidytuesday/2023-03-12-ggbrain-seg-sf/ggbrain_seg_sf.html" width="100%" height="400px" data-external="1">

</iframe>

-----

``` r
library(gganatogram)

a <- gganatogram(data=hgFemale_key, outline = T, fillOutline='#a6bddb', organism='human', sex='female', fill="colour") 

hgFemale_key$organ %>% length()
#> [1] 70


a + 
  ggstamp::stamp_wash() +
  geom_path(data = hgFemale_list$brain, aes(x = x, y = -y), color = "red", size = .5, linetype = "dashed") +
  coord_equal()
#> Warning in annotate(geom = "rect", xmin = xmin, ymin = ymin, xmax = xmax, :
#> Ignoring unknown aesthetics: x and y
#> Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
#> ℹ Please use `linewidth` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Warning: Removed 1 row containing missing values (`geom_path()`).
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r


hgFemale_list$liver %>% 
  rename(organ = id) %>% 
  left_join(hgFemale_key) ->
liver_with_other_info
#> Joining with `by = join_by(organ)`
```

# chat gpt? Confidently writes something…

write me a ggplot2 extension for circle packing:

Sure, here’s an example of a ggplot2 extension for circle packing:

``` r
# Load necessary packages
library(ggplot2)
library(grid)
library(gridExtra)
library(viridis)
library(dplyr)

# Define a function to create circle packing plot
circle_packing_plot <- function(data, size, color = NULL, palette = viridis::viridis, alpha = 0.8, ...) {
  
  # Prepare data for plotting
  data <- data %>%
    arrange(desc(size)) %>%
    mutate(id = row_number()) %>%
    mutate(parent = ifelse(id == 1, NA, id - 1)) %>%
    mutate(name = paste(id, "-", name)) %>%
    select(id, parent, name, size, color)
  
  # Calculate layout of circles
  layout <- packcircles(data$size)
  
  # Create a blank canvas to draw the plot
  canvas <- ggplot(data.frame(x = c(-1, 1), y = c(-1, 1)), aes(x = x, y = y)) +
    geom_blank() +
    coord_fixed() +
    theme_void() +
    theme(plot.margin = unit(c(1,1,1,1), "cm"))
  
  # Create a circle for each data point
  circles <- lapply(seq_len(nrow(data)), function(i) {
    gg <- ggplot(data[i, ], aes(x = layout$circle.x[i], y = layout$circle.y[i])) +
      geom_circle(aes(r = layout$radius[i], fill = color), alpha = alpha) +
      ggtitle(data$name[i]) +
      scale_fill_gradientn(colors = palette, na.value = "white") +
      guides(fill = FALSE) +
      theme_void()
    gg
  })
  
  # Combine the circles and the canvas into a single plot
  plot <- grid.arrange(
    grobs = circles,
    ncol = 1,
    widths = unit(1, "npc"),
    heights = unit(layout$height, "npc")
  )
  
  plot <- arrangeGrob(canvas, plot, nrow = 1, heights = c(0.15, 0.85))
  
  return(plot)
}

# Register the circle packing plot function as a ggplot2 extension
ggplot2::ggplot2_register_extension("circle_packing", circle_packing_plot)


# With this extension, you can create a circle packing plot by using the geom_circle_pack() function in ggplot2. Here's an example usage:

data(mtcars)

# Create circle packing plot
ggplot(mtcars, aes(size = mpg, color = wt)) +
  geom_circle_pack() +
  labs(title = "Circle Packing Plot of Cars") +
  scale_size_continuous(name = "Miles per Gallon") +
  scale_color_continuous(name = "Weight")
```
