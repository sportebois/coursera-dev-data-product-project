Titanic Survival prediction tool
========================================================
author: S. Portebois
date: 

The context
========================================================

On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. 
The sinking of the Titanic is one of the most infamous shipwrecks in history.  

If you were onboard, how likely were you to survive? 

This tool will let you get an idea of the answer.


Where comes the data from?
========================================================

In order to train a machine learning model, data with real passengers from the Titanic has been used. 
This data comes from the Kaggle training competition: [Titanic: Machine Learning from Disaster](https://www.kaggle.com/c/titanic)

Although the test dataset is useful for the competition, only the train dataset in used in this context to train a very simple linear regression model from 891 real passengers.


What are the computation involved
========================================================



After loading the csv file and setting the columns types, the model is trained from the train dataset to give the folowing coefficients:

```r
lmModel <- lm(Survived ~ Fare + Pclass + Sex + Age + Parch + SibSp - 1, train)
lmModel$coefficients
```

```
         Fare       Pclass3       Pclass2       Pclass1     Sexfemale 
 0.0002970713  0.2962135558  0.4873828591  0.6854298716  0.4886488850 
          Age         Parch         SibSp 
-0.0065370492 -0.0120393471 -0.0533661716 
```


What this prediction tool can do for you?
========================================================

Play with it [here on RPubs: https://sportebois.shinyapps.io/titanic](https://sportebois.shinyapps.io/titanic), you will be able to set 

- a candidate age (yours, or any hypothetical age)
- select male or female
- select if you are accompanied by any sibling or spouse
- select if you are accompanied by any children or parents
- select how much you would have paid for your ticket

To help you with the ticket price,  median values for 1st, 2nd and 3rd classes are given.
A graph will then be displayed, ploting the survival likelihood for any of the 3 classes, in function of the tocket price. Your select fare will be hilighted. 

