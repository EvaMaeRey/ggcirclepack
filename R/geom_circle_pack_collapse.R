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
#' group_by(continent) %>%
#'   filter(year == 2002) %>%
#'   # input must have required aesthetic inputs as columns
#'   count() %>%
#'   rename(area = n)
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
compute_panel_circle_pack_collapse <- function(data, scales, fun = sum){


  if(is.null(data$area)){

    data1 %>%
      mutate(area = 1) ->
      data1

  }

  data1 %>%
    group_by(across(c(linetype, color, fill))) %>%
    summarize(area = sum(area)) %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    packcircles::circleLayoutVertices(npoints = 300) %>%
    left_join(data1)

}


#'

StatCirclepackcollapse <- ggplot2::ggproto(`_class` = "StatCirclepackcollapse",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id", "linetype"),
                                  compute_panel = compute_panel_circle_pack_collapse,
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
#'   aes(id = continent) +
#'   geom_polygon_circlepack_collapse(alpha = .5, size = .002)
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
geom_polygon_circlepack_collapse <- function(mapping = NULL, data = NULL,
                           position = "identity", na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatCirclepackcollapse, # proto object from Step 2
    geom = ggplot2::GeomPolygon, # inherit other behavior
    data = data,
    mapping = mapping,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
