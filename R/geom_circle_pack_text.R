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
