library(survival) # for survival analysis
library(survminer) # Drawing Survival Curves using 'ggplot2'
library(lubridate) # for data manipulation
setwd("C:/Users/nimee/Documents/MSA Spring 2020/8200-Predictive Analytics/FinalProject")
library(readxl)
df1=read_excel("death_imputed_manual.xlsx") # not considered time of recovered cases
df = read_excel("death_imputed_DeathAndRecovery.xlsx")
colnames(df)
head(df)

df$Survival_Time[1:10]
df$SurvivalStatus[1:10]

data1 = Surv(df1$Survival_Time, df1$Status)
plot(survfit(data1 ~ 1),xlab = "Days",ylab = "Overall survival probability") 
# All the observations are alive for the first 8 days from the beginning of symptom onset date
# so here the survival probability is 100%
# We can also see that the chances of survival after 15 days is about 88% & reducing very fast after that
# which is becuse we haven't included the time of recovered cases in the data(120 days is considered as infinity)


#Let us include that data and check

data = Surv(df$Survival_Time, df$SurvivalStatus)
data[133:154]

## KM plot for one group
plot(survfit(data ~ 1),xlab = "Days",ylab = "Overall survival probability") 
# Survival Plot-yaxis: chance of survival after certain time period
# Now, we can see that the chances of survival after 30-40 days is above 95% & remains constant after that
#Dashed lines are CI, they are symmetric around the KP estimate
out = survfit(data ~ 1)
out$time
out$n.event
out$n.censor
out$n.risk

KMdata = cbind(out$time,out$n.event,out$n.censor,out$n.risk)
colnames(KMdata) = c("time","n.event","n.censor","n.risk")
View(KMdata) #Imp-Read the table
dim(df)


## KM plot for two groups -i.e include some explanatory variables
plot(survfit(data ~ df$gender),xlab = "Days",ylab = "Overall survival probability") #- survival curve calculation
ggsurvplot(survfit(data ~ df$gender),data = df)
#No matter what is the cutoff for the time, Survival Probability for for female is always greater
#than the survival probability for male. i.e Death Rate for male is high
#This is a good visual check to see the significance between the two groups
#there is slight crossing in the beginning so we can't say which group has higher SP

## logrank test-statistical check to see if there is any systematic pattern btw gender & survaival probability

survdiff(data ~ df$gender) 
## null hypothesis: there is no difference in the survival curve for male vs. female
#Since p-value is low, null hyp is rejected.
#Conclusion: there is a significant diff of SP for male & female as we saw in the plot

## What is the 1 month survival rate? : % survial after 30 days
#i.e what is the prob that a person will survive at 30 days

## naive way:  
n = nrow(df)
sum(df$Survival_Time[df$SurvivalStatus==2]<30) ## 44 dead by end of 30 days i.e. underestimation of death out of my sample
1-44/n ## 95.48% is the survial rate after 30 days ## i.e over-estimated survival rate by using naive way
table(df$SurvivalStatus)
#coz we don't get to observe death time for every individual coz there are some people who are censored
#i.e we don't get to observe their survival time

#Solution: Survival Curve Plot (See from X to Y)
summary(survfit(data ~ 1), times = 30) ## 30 days survival rate = 95.4%% which is equal to the naive way calculation because of the less sample data
#or we can extract the survival probability from the output and check in the data set
out = survfit(data ~ 1)
KMdata = cbind(out$time,out$n.event,out$n.censor,out$n.risk,out$surv)
colnames(KMdata) = c("time","n.event","n.censor","n.risk","survival rate")
View(KMdata) # Read the table


######################################################
##
##  part II: cox regression model and hazard ratio - helps us to evaluate how a varaible will have an effect on the survival rate
##
########################################################

out2 = coxph(Surv(Survival_Time, SurvivalStatus) ~ gender, data = df)
out2
#firstly, p is low, so gender is very useful in terms of explaining the survival time which is the
#same conclusion we get by running the log rank test

# higher HR means faster the death/failure rate
# HR =0.3639 ration between hazard for female vs hazard for male
#Since .36 < 1 it means that the hazard for female is less than hazard for male
#Dying Rate for female is 0.36 times as that of male at any given time

ggforest(out2, data = df)

#Model Evaluation

#install.packages("tidyverse")
library("tidyverse")
#install.packages("purrr")
#require("purrr")
#require(dplyr)
## https://github.com/tidyverse/tibble/issue s/395
## Used for the dataset.
library(survival)
## Used for visualizaiton.
library(survminer)

## Plot
ggsurvplot(survfit(Surv(Survival_Time, SurvivalStatus) ~ 1,data = df), risk.table = TRUE,break.time.by = 120)


## Fit a Cox model & understand whether it provides a good fit-starting point
coxph1 <- coxph(formula = Surv(Survival_Time, SurvivalStatus) ~ pspline(gender, df = 4) + factor(resid.ds) + factor(rx) + factor(ecog.ps),
                data    = df)
## Obtain the linear predictor
df$lp <- predict(coxph1, type = "lp")
View(df)

#helps with level of ranking for dangerousness of each subject-dangerousness score
