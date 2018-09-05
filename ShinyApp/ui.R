suppressPackageStartupMessages(c(
        library(shinythemes),
        library(shiny),
        library(tm),
        library(stringr),
        library(markdown),
        library(stylo)))

shinyUI(navbarPage("Coursera: Data Science Capstone", 
                   
                   theme = shinytheme("journal"),
                   
############################### ~~~~~~~~1~~~~~~~~ ##############################  
## Tab 1 - Prediction

tabPanel("Word Prediction App",
         tags$head(includeScript("./js/ga-shinyapps-io.js")
                   ),
          sidebarLayout(
            sidebarPanel(
              includeHTML("sidebar.html"),
              hr(),
              "© 2018 - ",
              a(
                href="https://www.linkedin.com/in/javierngkh/",
                target="_blank",
                "Ng Kok How Javier")
            ), 
            mainPanel(id="mainpanel",
                              tags$div(textInput("text", 
                                        label = h3("Enter your word/phrase:"),
                                        value = ),
                              br(),
                              h4("Predicted next word:"),
                              tags$span(style="color:red",
                                        tags$strong(tags$h2(textOutput("predictedWord")))),
                              br(),
                              tags$hr(),
                              h4("What you have entered:"),
                              tags$em(tags$h4(textOutput("enteredWords"))),
                              align="left")
               )
      )),

############################### ~~~~~~~~2~~~~~~~~ ##############################
## Tab 2 - About 

tabPanel("About",
         fluidRow(
                 column(2,
                        p("")),
                 column(8,
                        includeMarkdown("./about/about.md")),
                 column(2,
                        p(""))
         )
)))
