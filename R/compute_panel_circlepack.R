# Step 1
#' compute_panel_circlepack
#'
#' @param data
#' @param scales
#'
#' @return
#' @export
#'
#' @examples
#' TBD
compute_panel_circlepack <- function(data, scales, count = F){

  if(is.null(data$area)){data$area <- 1}
  
    if(is.null(data$area)){data$area <- 1}
  
   # if(!("weight" %in% names(data))){data$weight <- 1}
  # order matters... Need to add text aesthetics
  if("id" %in% names(data)){data <- group_by(data, id, .add = T)}

  if("fill" %in% names(data)){data <- group_by(data, fill, .add = T)}
  if("alpha" %in% names(data)){data <- group_by(data, alpha, .add = T)}
  if("colour" %in% names(data)){data <- group_by(data, colour, .add = T)}
  if("group" %in% names(data)){data <- group_by(data, group, .add = T)}
  if("linetype" %in% names(data)){data <- group_by(data, linetype, .add = T)}
  if("linewidth" %in% names(data)){data <- group_by(data, linewidth, .add = T)}
  
  if(count){
  data %>% 
    mutate(id = as.integer(as.factor(id))) %>% 
    count(wt = area) %>% 
    rename(area = n) ->
    data
  } else { data$id = 1:nrow(data)}
  
  # data %>%
  #   mutate(id = row_number()) ->
  #   data1

  # if(is.null(data$area)){
  # 
  #   data1 %>%
  #     mutate(area = 1) ->
  #     data1
  # 
  # }

  data %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    packcircles::circleLayoutVertices(npoints = 50) %>%
    left_join(data) #%>%

}
