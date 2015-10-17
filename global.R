
library(ggplot2)

library(readr)
library(dplyr)

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
# rawTest <- read_csv(file = "./data-in/test.csv", col_types = col_types)

# Remove the obviously not relevant features
train <- rawTrain %>% select( -Name, -Ticket, -Cabin) 
lmModel <- lm(Survived ~ Fare + Pclass + Sex + Age + Parch + SibSp - 1, train)

# rfModel <- train(Survived ~ Fare + Pclass + Sex + Age + Parch + SibSp -1, train, method = "rf")

# Return the median fares for each passenger class
fareDetails <- list(
  "medianFare" = (train %>% summarise(medianFare = median(Fare)))[[1, 1]],
  "minFare" = (train %>% summarise(minFare = min(Fare)))[[1, 1]],
  "medianFare1" = (train %>% filter(Pclass == 1) %>% summarise(medianFare = median(Fare)))[[1, 1]],
  "minFare1" = (train %>% filter(Pclass == 1) %>% summarise(medianFare = min(Fare)))[[1, 1]],
  "maxFare1" = (train %>% filter(Pclass == 1) %>% summarise(medianFare = max(Fare)))[[1, 1]],
  "medianFare2" = (train %>% filter(Pclass == 2) %>% summarise(medianFare = median(Fare)))[[1, 1]],
  "minFare2" = (train %>% filter(Pclass == 2) %>% summarise(medianFare = min(Fare)))[[1, 1]],
  "maxFare2" = (train %>% filter(Pclass == 2) %>% summarise(medianFare = max(Fare)))[[1, 1]],
  "medianFare3" = (train %>% filter(Pclass == 3) %>% summarise(medianFare = median(Fare)))[[1, 1]],
  "minFare3" = (train %>% filter(Pclass == 3) %>% summarise(medianFare = min(Fare)))[[1, 1]],
  "maxFare3" = (train %>% filter(Pclass == 3) %>% summarise(medianFare = max(Fare)))[[1, 1]]
)