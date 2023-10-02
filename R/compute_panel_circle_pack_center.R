#' compute_panel_circle_pack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
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
