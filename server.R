
shinyServer(function(input, output, session){
  
  observe({
    stratificationOutcome <- input$stratOutcome
    filteredEstimationOutcomes <- readRDS("data/relative.rds") %>%
      left_join(outcomes, by = c("stratOutcome" = "idNumber")) %>%
      filter(label == stratificationOutcome) %>%
      select(estOutcome) %>%
      left_join(outcomes, by = c("estOutcome" = "idNumber")) %>%
      .$label
    
    updateSelectInput(session = session,
                      inputId = "estOutcome",
                      choices = unique(filteredEstimationOutcomes))
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
                         absolute = res$absolute,
                         target = input$target,
                         comparator = input$comparator)
    return(plot)
    
  }, height = function() {
    0.65*session$clientData$output_combinedPlot_width
  })
})