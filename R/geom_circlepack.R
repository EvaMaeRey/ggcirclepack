StatCirclepack <- ggplot2::ggproto(`_class` = "StatCirclepack",
                                  `_inherit` = ggplot2::Stat,
                                  required_aes = c("id"),
                                  compute_panel = compute_panel_circlepack,
                                  default_aes = ggplot2::aes(group = after_stat(id))
                                  )

GeomPolygonPale <- ggplot2::ggproto(`_class` = "GeomPolygonPale",
                           `_inherit` = ggplot2::GeomPolygon,
                           default_aes = modifyList(
                             ggplot2::GeomPolygon$default_aes,
                             ggplot2::aes(fill = from_theme(
                               fill %||% scales::col_mix(ink, paper, 0.8)))))

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
stat_circlepack <- ggplot2::make_constructor(StatCirclepack, geom = GeomPolygonPale)



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
geom_circlepack <- ggplot2::make_constructor(GeomPolygonPale, stat = StatCirclepack)
