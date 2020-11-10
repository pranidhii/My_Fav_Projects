library(survival) # for survival analysis
library(survminer) # Drawing Survival Curves using 'ggplot2'
library(lubridate) # for data manipulation
setwd("/Users/pranidhiprabhat/Desktop/MSA/Spring/PA/Final\ Project")
library(readxl)

# Data includes both recovery and death cases with death marked as 120 ( infinity)
df = read_excel("death_imputed_DeathAndRecovery.xlsx")
colnames(df)
head(df)
df = df[df$agebin!=0,]


df$Recovery_Time[1:10]
df$RecoveryStatus[1:10]

data = Surv(df$Recovery_Time, df$RecoveryStatus)
datadeath = Surv(df$Survival_Time,df$SurvivalStatus)
data[133:154]

## KM plot for one group
plot(survfit(data ~ 1),xlab = "Days",ylab = "Overall recovery probability")
plot(survfit(datadeath ~ 1),xlab = "Days",ylab = "Overall survival probability")
# Survival Plot-yaxis: chance of not recovering after certain time period
# Now, we can see that the chance of not recovering after 30 days is above 80% & remains constant after that

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
plot(survfit(data ~ df$agebin),xlab = "Days",ylab = "Overall recovery probability") #- survival curve calculation
ggsurvplot(survfit(data ~ df$agebin),data = df)

plot(survfit(datadeath ~ df$agebin),xlab = "Days",ylab = "Overall Survival probability") #- survival curve calculation
ggsurvplot(survfit(datadeath ~ df$agebin),data = df)


survdiff(data ~ df$gender12) 


## naive way:  
n = nrow(df)
sum(df$Recovery_Time[df$RecoveryStatus==2]<30) ## 44 dead by end of 30 days i.e. underestimation of death out of my sample
1-42/n ## 95.13% is the survial rate after 30 days ## i.e over-estimated survival rate by using naive way
table(df$RecoveryStatus)
#coz we don't get to observe death time for every individual coz there are some people who are censored
#i.e we don't get to observe their survival time

#Solution: Survival Curve Plot (See from X to Y)
summary(survfit(data ~ 1), times = 30.25) ## 30 days survival rate = 95.4%% which is equal to the naive way calculation because of the less sample data
#or we can extract the survival probability from the output and check in the data set
out = survfit(data ~ 1)

# or use  : use any one 
KMdata = cbind(out$time,out$n.event,out$n.censor,out$n.risk,out$surv)
colnames(KMdata) = c("time","n.event","n.censor","n.risk","recovery rate")
View(KMdata) # Read the table


######################################################
##
##  part II: cox regression model and hazard ratio - helps us to evaluate how a varaible will have an effect on the survival rate
##
########################################################

out2 = coxph(Surv(Recovery_Time, RecoveryStatus) ~ gender12, data = df)
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
ggsurvplot(survfit(Surv(Recovery_Time, RecoveryStatus) ~ 1,data = df), risk.table = TRUE,break.time.by = 120)
