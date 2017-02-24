# server logic for interactive scatterplot building

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # instantiate the empty plot
  output$scatterPlot <- renderPlot({
    ggplot(data.frame()) + geom_point() + xlim(c(-2,2)) + ylim(c(-2,2)) +
      theme_minimal()
  })

  # instantiate covariance and r-value display
  output$covval <- renderUI(h4("cov = "))
  output$rval <- renderUI(h4("r = "))
  #output$pval <- renderUI(h4("p = "))

  # create empty dataframe
  params <- reactiveValues()
  params$scat.df <- data.frame()
  

  # on plot_click
  observeEvent(input$plot_click, {
    
    # bind click position to dataframe
    params$scat.df <- rbind(params$scat.df, data.frame(x=input$plot_click$x, y=input$plot_click$y))
    
    # update the output - basic plot without means drawn
    scatterPlot <- ggplot(params$scat.df, aes(x=x, y=y)) + geom_point() + 
      xlim(c(-2,2)) + ylim(c(-2,2)) + theme_minimal()
    
    # include means if input$includeMeans is checked
    if (input$includeMeans == TRUE) {
      scatterPlot <- scatterPlot + 
        geom_hline(yintercept = mean(params$scat.df$y), linetype="dashed", colour="grey") +
        geom_vline(xintercept = mean(params$scat.df$x), linetype="dashed", colour="grey")
    }
    
    # plot it
    output$scatterPlot <- renderPlot(scatterPlot)
    
    # compute r if n >= 2
    if (nrow(params$scat.df) >= 2) {
      
      # get cov and Pearson's r
      covval <- round(with(params$scat.df, cov(x, y)), 4)
      rval <- round(with(params$scat.df, cor(x, y)), 4)
      
      # get probability value
      #s <- (rval * sqrt(nrow(params$scat.df)-1))/sqrt(1-rval^2)
      #pval <- round(pt(abs(s), nrow(params$scat.df)-1, lower.tail=FALSE), 3)
      
      # send to UI
      output$covval <- renderUI(h4(paste("cov = ", covval, sep="")))
      output$rval <- renderUI(h4(paste("r = ", rval, sep="")))
      #output$pval <- renderUI(h4(
      #  ifelse(pval > 0, paste("p = ", pval, sep=""), "p < .001")
      #))
    } else {
      output$covval <- renderUI(h4("cov = "))
      output$rval <- renderUI(h4("r = "))
      #output$pval <- renderUI(h4("p = "))
    }
    
  })
  
  # on input$clearPlot click, clear everything
  observeEvent(input$clearPlot, {
    # instantiate the empty plot
    output$scatterPlot <- renderPlot({
      ggplot(data.frame()) + geom_point() + xlim(c(-2,2)) + ylim(c(-2,2)) +
        theme_minimal()
    })
    
    # instantiate cov and r-value display
    output$covval <- renderUI(h4("cov = "))
    output$rval <- renderUI(h4("r = "))
    #output$pval <- renderUI(h4("p = "))
  
    params$scat.df <- data.frame()
  })

})
