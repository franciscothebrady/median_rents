#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#




# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  library(shiny)
  library(dplyr)   
  library(ggplot2)
  library(viridis)
  output$rentmap <- renderPlot({
    
    rents_df%>% 
      dplyr::filter(type == input$type,
                    year == input$year) %>%
    ggplot() +
      geom_polygon(aes(x = long, y = lat, group = group, 
                       fill = median_rent), 
                   colour="darkgray", size=.1) +
      scale_fill_gradientn(colours = c("darkgreen","orange","red")) +
      coord_fixed(1.3) + theme_void()
    
    
  })
  
})
