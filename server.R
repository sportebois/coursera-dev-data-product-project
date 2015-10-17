library(shiny)
# library(caret)

function(input, output) {
  output$fareDetails <- reactive({fareDetails})
  
  output$plot <- renderPlot({
    # Compute the survival rate for a fare range, and plot this predicted survival rate
    
    maxFare <- 250
    
    userData <- data.frame(
      Sex = input$sex,
      Age = input$age,
      Parch = input$parch, 
      SibSp = input$sibSp,
      userFare = input$fare
      )
#     dataFare <- data.frame(
#       Fare = rep.int(seq(1:maxFare), 3), 
#       Pclass = rep(as.factor(c(1,2,3)), each = maxFare)
#       )
    dataFare <- dplyr::bind_rows( 
      data.frame(Fare = seq(0:300), Pclass = rep(1, 301)),
      data.frame(Fare = seq(0:75), Pclass = rep(2, 76)),
      data.frame(Fare = seq(0:70), Pclass = rep(3, 71))
    )
    dataFare$Pclass <- factor(dataFare$Pclass, ordered = TRUE, levels = c("3", "2", "1"))
      
    # We need as much copies of userData as fare*class combinations
    expandedUserData <- userData[rep(row.names(userData), nrow(dataFare)), ]
    newData <- dplyr::bind_cols(dataFare, expandedUserData)
    predData <- newData %>% mutate(Survival = predict(lmModel, newData)  )
    
    plot <- ggplot(predData, aes(Fare, Survival)) +
      scale_y_continuous(limits = c(0, 1)) +
      geom_point(aes(color = Pclass)) +
      facet_grid(Pclass ~ .) +
      geom_vline( aes( xintercept = userFare, linetype = "userFare"), 
                  colour = "red", show_guide = TRUE) +
      labs(title = "Titanic survival prediction depending on price and passenger class") +
      guides(colour = guide_legend(override.aes = list(linetype = 0 )),
             fill = guide_legend(override.aes = list(linetype = 0 )),
             shape = guide_legend(override.aes = list(linetype = 0 )), 
             linetype = guide_legend()) +
      scale_linetype_manual(name = "", labels = c("your fare"), values = c( "userFare" = 1))
    
    print(plot)
  }, height = 700)
  
}