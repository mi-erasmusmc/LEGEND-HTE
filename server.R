
shinyServer(function(input, output, session){
  
  # Not required at the moment. It updates the input options for different exposure groups
  observe({
    indicationId <- input$indication
    exposureGroup <- input$exposureGroup
    filteredExposures <- exposures[exposures$indicationId == indicationId, ]
    filteredExposures <- filteredExposures[filteredExposures$exposureGroup == exposureGroup, ]
    updateSelectInput(session = session,
                      inputId = "target",
                      choices = unique(filteredExposures$exposureName))
    updateSelectInput(session = session,
                      inputId = "comparator",
                      choices = unique(filteredExposures$exposureName))
  })
  
  resultSubset <- reactive({
    
    results <- getResults(targ = input$target,
                          comp = input$comparator,
                          strat = input$stratOutcome,
                          est = input$estOutcome,
                          db = input$database,
                          ind = input$indication,
                          anal = input$analysis)
    
    return(results)
    
  })
  
  output$mainTableRelative <- DT::renderDataTable({
    
    res <- resultSubset()
    
    table <- res$relative %>%
      select(estimate, lowerBound, upperBound, riskStratum, database) %>%
      datatable() %>%
      formatRound(columns= c("estimate", "lowerBound", "upperBound"), digits=2)
    
    return(table)
    
  })
  
  output$mainTableAbsolute <- DT::renderDataTable({
    
    res <- resultSubset()

    table <- res$absolute %>%
      mutate(estimate = 100*estimate,
             lowerBound = 100*lowerBound,
             upperBound = 100*upperBound) %>%
      select(estimate, lowerBound, upperBound, riskStratum, database) %>%
      datatable() %>%
      formatRound(columns= c("estimate", "lowerBound", "upperBound"), digits=2)
      
    return(table)
    
  })
 
  output$combinedPlot <- renderPlot({
    
    res <- resultSubset()
    
    plot <- combinedPlot(cases = res$cases,
                         relative = res$relative,
                         absolute = res$absolute)
    return(plot)
    
  })
})