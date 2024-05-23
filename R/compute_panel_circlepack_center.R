#' compute_panel_circlepack_center
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
compute_panel_circlepack_center <- function(data, scales){

  # get aes names as they appear in the data
  data_mapped_aes_names <- names(data)[names(data) %in% c("id", "fill", "alpha", 
                                             "colour", "group", "linewidth", 
                                             "linetype")]
  
  if(is.null(data$area)){data$area <- 1}
  
  data %>% 
    group_by(across(data_mapped_aes_names)) ->
  data
  
  data %>% 
    count(wt = area) %>% 
    arrange(id) %>% # this doesn't feel very principled
    rename(area = n) ->
  data

  data %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    cbind(data) 

}
