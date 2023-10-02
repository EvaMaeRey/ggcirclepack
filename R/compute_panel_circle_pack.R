# Step 1
#' compute_panel_circle_pack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' TBD
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
