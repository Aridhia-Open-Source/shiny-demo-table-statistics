documentation_tab <- function() {
  tabPanel("Information",
           # load MathJax library so LaTeX can be used for math equations
           withMathJax(), 
           h3("Summarising Your Datasets"), # paragraph and bold text
           p("This app allows you to view your workspace datasets and a selection of summary statistics
             about each variable within."),
           p("In addition, each variable can be displayed as a histogram, showing the distribution
             of the data."),
           br(),
           h4("To use the app"),
           p("The layout of the app contains two", strong("tabs,"), 
             "the first of which (Information) you are reading, and the second (Application) containing the application output.
              This shows a summary of each variable, its type, the number of missing values, and basic statistics."),
           br(),
           p("To use, first click on the Application tab, and then select your dataset of interest from the ", 
             em("drop down box."), "To refresh the list of datasets available, click ", em("Refresh Table List."),
             "To view a preview of the table you have selected, click ", em("Preview Table.")),
            p("Additional statistics for each variable can be found by clicking on", em("details.")),
           p("To view a histogram of your variable of interest, just click anywhere on the row containing the variable."),
           
            
            
           br(),
           p("The video below gives an overview on how to use the app:"),
           HTML('<iframe width="100%" height="500" src="//www.youtube.com/embed/rCDZzf4ragg" frameborder="0"></iframe>'),
           p(strong("NB: This R Shiny app is provided unsupported and at user's risk. If you
                               are planning to use this app to inform your study, please review the
                    code and ensure you are comfortable with the calculations made.")
           )
           
           )
}