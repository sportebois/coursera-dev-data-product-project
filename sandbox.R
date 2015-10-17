
# Install Shiny
devtools::install_github('rstudio/rsconnect')
library(rsconnect)
# rsconnect::setAccountInfo(name='sportebois', token='YTOKEN', secret='MYSECRET')
# deployApp()
# Load the packages -------------------------------------------------------


library(readr)
library(dplyr)
library(ggplot2)
# library(caret)

# Prepare to format the factors ------------------------------------------------------
col_types <- list(
  Sex = readr::col_factor(c("male", "female")),
  Pclass = readr::col_factor(c(3, 2, 1), ordered = TRUE),
  Age = readr::col_numeric(),
  Parch = readr::col_integer(),
  SibSp = readr::col_integer(),
  Embarked = readr::col_factor(c("C", "Q", "S"))
)

# Survived 0 (false) 1 (true)
# Pclass 1 < 2 < 3
# Sex male/female
# SibSp == Number of Siblings/Spouses Aboard
# parch == Number of Parents/Children Aboard


# Load the csv data -------------------------------------------------------
rawTrain <- read_csv(file = "./data-in/train.csv", col_types = col_types)
rawTest <- read_csv(file = "./data-in/test.csv", col_types = col_types)

# Remove the obviously not relevant features
train <- rawTrain %>% select( -Name, -Ticket, -Cabin) 
lmModel <- lm(Survived ~ Fare + Pclass + Sex + Age + Parch + SibSp - 1, train)
# plot(lmModel)

# rfModel <- train(Survived ~ Fare + Pclass + Sex + Age + Parch + SibSp -1, train, method = "rf")
#predictData <- data.frame(Fare = 100, Pclass=as.factor(2), Sex="male", Age=38, Parch=0, SibSp=1)
#predict(lmModel, predictData)

maxFare <- 250
userData <- data.frame(Sex="male", Age=30, Parch=1, SibSp=1)
dataFare <-  data.frame(Fare = rep.int(seq(1:maxFare), 3), Pclass = rep(as.factor(c(1,2,3)), each=maxFare))
# We need as much copies of userData as fare*class combinations
expandedUserData <- userData[rep(row.names(userData), maxFare*3), ]
newData <- dplyr::bind_cols(dataFare, expandedUserData)
predData <- newData %>% mutate(Survival = predict(lmModel, newData)  )

ggplot(predData, aes(Fare, Survival)) +
  scale_y_continuous(limits = c(0, 1)) +
  geom_point(aes(color = Pclass)) +
  facet_grid(Pclass ~ .) +
  geom_vline( aes( xintercept = 126, linetype = "userFare"), colour="red", show_guide = TRUE) +
  labs(title="Titanic survival prediction depending on price and passenger class") +
  guides(colour = guide_legend(override.aes = list(linetype = 0 )),
         fill = guide_legend(override.aes = list(linetype = 0 )),
         shape = guide_legend(override.aes = list(linetype = 0 )), 
         linetype = guide_legend()) +
  scale_linetype_manual(name = "", labels = c("your fare"), values = c( "userFare" = 1))
