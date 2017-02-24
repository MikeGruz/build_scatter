# ui for interactive scatterplot building

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Build a Scatterplot"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("covval"),
      uiOutput("rval"),
      uiOutput("pval"),
      checkboxInput("includeMeans", "Plot means"),
      actionButton("clearPlot", "Clear Plot")

    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("scatterPlot", click="plot_click", width="600px", height="600px")
    )
  )
))
