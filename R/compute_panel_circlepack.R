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
compute_panel_circlepack <- function(data, scales, npoints = 50, fun = sum){

  # get aes names as they appear in the data
  
  if(is.null(data$slice)){data$slice <- TRUE}

  data %>% 
    dplyr::filter(.data$slice) ->
  data
  
  grp_cols <-  c("id", "fill", "alpha", 
                 "colour", "group", "linewidth", "label", "size",
                 "linetype", "render")
  
  # Thanks June! https://github.com/teunbrand/ggplot-extension-club/discussions/15
  data %>% 
    group_by(group_by(pick(any_of(grp_cols)))) ->   
  data
  
  if(is.null(data$area)){data$area <- 1}
  if(is.null(data$wt)){data$wt <- 1}
  
  data %>% 
    summarize(area = fun(.data$area*.data$wt), .groups = 'drop') ->
  data
    
  data %>%   
    arrange(id)  -> # this doesn't feel very principled; motivation is when you go from no fill to color, preserves circle position...
  data
  
  if(is.null(data$within)){data$within <- 1}

  data %>%   
    group_by(.data$within) %>% 
    mutate(prop = .data$area/sum(.data$area)) %>%
    mutate(percent = round(.data$prop*100)) -> 
  data

  data$id = 1:nrow(data)

  data %>%
    pull(area) %>%
    packcircles::circleProgressiveLayout(
      sizetype = 'area') %>%
    packcircles::circleLayoutVertices(npoints = npoints) %>%
    left_join(data, by = join_by(id)) 

}
