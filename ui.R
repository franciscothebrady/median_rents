#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Median Rents in the United States"),
  # load the data
  # rents <- read_rds("data.Rds")
  # Sidebar with a selectInput for Year of data 
  sidebarLayout(
    sidebarPanel(
       selectInput(inputId = "year", choices = unique(rents_df$year), label = "Select Year"),
       selectInput(inputId = "type", 
                  choices =c("studio", "1 bedroom", "2 bedroom", "3 bedroom", "4 bedroom"), 
                  label = "Select Rental Type", 
                  selected = "Studio")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("rentmap"))
    
  )
))
