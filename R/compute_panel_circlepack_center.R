#' compute_panel_circlepack_center
#'
#' @return
#' @export
#'
#' @examples
compute_panel_circlepack_center <- function(data, scales){

  # get aes names as they appear in the data
  data_mapped_aes_names <- names(data)[names(data) %in% 
                                         c("id", "fill", "alpha", 
                                             "colour", "group", "linewidth", "label",
                                             "linetype", "render")]
  
  if(is.null(data$area)){data$area <- 1}
  data$value <- data$area
  
  data %>% 
    group_by(across(data_mapped_aes_names)) ->
  data
  
  data %>% 
    count(wt = area) %>% 
    # ungroup() %>%
    arrange(id) %>% # this doesn't feel very principled; motivation is when you go from no fill to color, preserves circle position...
    rename(area = n) ->
  data

  data %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    cbind(data) ->
  data
  
  if(!is.null(data$render)){
    
    data %>% 
      mutate(auto_label = ifelse(.data$render, 
                                 as.character(.data$id), NA)) ->
    data
    
  }else{
    
    data %>% 
      mutate(auto_label = id) ->
    data
    
  }
  
  data
}

