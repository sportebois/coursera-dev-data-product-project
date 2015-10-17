library(shiny)


fluidPage(
  
  titlePanel("Titanic survival simulator"),
  
  sidebarPanel(
    p(
      span("Set a few values for predictors, and read on the right side of the page the predicted survival odds during the 
  Titanic wreckage. These predictions are based on a linear model trained from 891 real passengers observations. Data comes from the "),
      a("Titanic Kaggle's machine learning competition", href = "https://www.kaggle.com/c/titanic/data"),
      br(),
      span("The predicted survival value goes from 0 (no chance of survival) to 1 (certain to escape the wreckage).")
    ),
    hr(),
    sliderInput('age', 'Your age', min = 1, max = 90, value = 30),
    
    radioButtons('sex', "Your sex", 
                       c("Male" = "male", 
                         "Female" = "female"), 
                       selected = "male", inline = TRUE),
    sliderInput('sibSp', 'Number of Siblings/Spouses Aboard', min = 0, max = 6, value = 0),
    sliderInput('parch', 'Number of Parents/Children Aboard', min = 0, max = 6, value = 0),
    
    span(paste("To you an idea of the prices, the medias values for 1st, 2nd and 3rd passengers classes were", 
               round(fareDetails$medianFare1, 2), "$ in 1st class, ",
               round(fareDetails$medianFare2, 2), "$ in 2nd class, and ", 
               round(fareDetails$medianFare3, 2), "$ in 3rd class")),
    
    sliderInput('fare', 'The fare you would have paid for the transatlantic trip', 
                min = 1, max = 250, value = fareDetails$medianFare)
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)
