shinyUI(
  fluidPage(
    
    style = "width:1500px;",
    titlePanel(
      title=div(img(src = "logo.png", height = 50, width = 50), 
                "LEGEND Risk based HTE"),
      windowTitle = "LEGEND Risk based HTE"),
    tags$head(tags$style(type = "text/css", "
                         #loadmessage {
                         position: fixed;
                         top: 0px;
                         left: 0px;
                         width: 100%;
                         padding: 5px 0px 5px 0px;
                         text-align: center;
                         font-weight: bold;
                         font-size: 100%;
                         color: #000000;
                         background-color: #ADD8E6;
                         z-index: 105;
                         }
                         ")),
    tabsetPanel(
      
      id = "mainTabsetPanel",
      tabPanel("About",
               HTML("</BR><P>This app is under development. All results are preliminary and may change without notice.</P>"),
               HTML("</BR><P>Do not use.</P>")
      ),
      
      tabPanel("Results",
               fluidRow(
                 column(
                   3,
                   selectInput("indication", 
                               "Indication",
                               indications$indicationId, 
                               selected = "Hypertension"),
                   selectInput("exposureGroup", 
                               "Exposure group",
                               unique(exposures$exposureGroup), 
                               selected = "Drug major class"),
                   selectInput("target", 
                               "Target", 
                               unique(exposures$exposureName),
                               selected = "Ace inhibitors"),
                   selectInput("comparator", 
                               "Comparator", 
                               unique(exposures$exposureName), 
                               selected = "Beta blockers"),
                   selectInput("stratOutcome", 
                               "Stratification Outcome", 
                               unique(outcomes$label),
                               "Total cardiovascular disease"),
                   selectInput("estOutcome", 
                               "Estimation outcome",
                               unique(outcomes$label)),
                   checkboxGroupInput("database", 
                                      "Database", 
                                      databases$databaseId, 
                                      selected = "CCAE"),
                   checkboxGroupInput("analysis",
                                      "Analysis", 
                                      analyses$analysisId,
                                      "IPTW")
                 ),
                 column(
                   9,
                   tabsetPanel(id = "relativePanel",
                               tabPanel("Relative", 
                                        DT::dataTableOutput("mainTableRelative")),
                               tabPanel("Absolute",
                                        DT::dataTableOutput("mainTableAbsolute")),
                               tabPanel("Plot",
                                        plotOutput("combinedPlot")))
                 )
               ))
      
    )
    
    )
)