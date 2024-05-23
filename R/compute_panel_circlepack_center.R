#' compute_panel_circlepack_center
#'
#' @return
#' @export
#'
#' @examples
#' # TBD
compute_panel_circlepack_center <- function(data, scales, count = F){

  # data ->
  #   data1
  
  # get aes names as they appear in the data
  data_mapped_aes_names <- names(data)[names(data) %in% c("id", "fill", "alpha", 
                                             "colour", "group", "linewidth", 
                                             "linetype")]
  
  if(is.null(data$area)){data$area <- 1}
  
  data %>% 
    group_by(across(data_mapped_aes_names)) ->
  data
   # if(!("weight" %in% names(data))){data$weight <- 1}
  # order matters... Need to add text aesthetics
  # if("id" %in% names(data)){data <- group_by(data, id, .add = T)}
  # if("fill" %in% names(data)){data <- group_by(data, fill, .add = T)}
  # if("alpha" %in% names(data)){data <- group_by(data, alpha, .add = T)}
  # if("colour" %in% names(data)){data <- group_by(data, colour, .add = T)}
  # if("group" %in% names(data)){data <- group_by(data, group, .add = T)}
  # if("linetype" %in% names(data)){data <- group_by(data, linetype, .add = T)}
  # if("linewidth" %in% names(data)){data <- group_by(data, linewidth, .add = T)}
  
  
  if(count){
  data %>% 
    count(wt = area) %>% 
    rename(area = n) ->
    data
  }

  data %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    cbind(data) %>%
    mutate(label = id)

}
