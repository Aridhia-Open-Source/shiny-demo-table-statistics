documentation_tab <- function() {
  tabPanel("Information",
           # load MathJax library so LaTeX can be used for math equations
           withMathJax(), 
           h3("Using the t-test to compare group means"), # paragraph and bold text
           p("This app allows you to visually compare ."),
           br(),
           p("The layout of the app contains one", strong("sidebar,"), "and two", strong("tabs"), 
             "the first of which (Information) you are reading, and the second (Application) containing the application output
              with the regression plot and statistical results."),

           
           # break used to space sections
           br(),
           h4("To use the app:"),
           p("To experiment with linear regressions on your workspace datasets, in the ",
             strong("sidebar"), 
             " you may: "), 
           br(), # ordered list
           tags$ol(
             tags$li("In the first ", em("drop down box, "), 
                     "select the database to be used. The ", em("Refresh table list"), "button updates the tables you can select if 
                      any workspace datasets are changed."), 
             tags$li("In the second ", em("drop down box, "), 
                     "pick the resulting variable of the regression."), 
             tags$li("In the third ", em("drop down box, "), 
                     "choose one of the regressors for the linear regression."), 
             tags$li("In the following", em("drop down box "),
                     "you are able to define which one, of the several predefined linear models, will be used."),
             tags$li("Finally, in the ", em("check boxes "),
                     "you can define characteristics of the resulting plot.")
            
             ),
           br(),
           p(strong("NB: This R Shiny app is provided unsupported and at user's risk. If you
                               are planning to use this app to inform your study, please review the
                    code and ensure you are comfortable with the calculations made.")
           )
           
           )
}