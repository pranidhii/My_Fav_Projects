## A/B Testing on Kaggle Dataset

Link to the data - /kaggle/input/how-to-do-product-analytics/product.csv

There are two site_version in the given data - mobile and desktop. In this notebook we are trying to figure out on which site_version is better in yielding better results.

#### Choosing the Success Metric
In this case the metric of choice is the 'target'. 'target' as 1 means sales conversion while 0 means no sales.

#### Other
Practical significance is the minimum change to the baseline rate that is useful to the business, for example an increase in the conversion rate of 0.001% may not be worth the effort required to make the change whereas a 2% change is potential enough to go for the change. The value in this case is defined as 1%

Confidence level also called significance level is the probability that the null hypothesis is rejected when it shouldn’t be rejected. The value in this case is defined as 5%

#### Hypothesis :
I’ll test the null hypothesis that the probability of target conversion in the mobile group minus the probability of target conversion in the desktop group equals zero. And set the alternative hypothesis to be that the probability of conversion in the mobile group minus the probability of conversion in the desktop group does not equal zero. The significance level for the experiment is 1%

#### About the Data
The data has the following columns. The data dictionary has been assumed as the following :

order_id - unique purchase number (NA for banner clicks and impressions)
user_id - unique identifier of the client
page_id - unique page number for event bundle (NA for purchases)
product - banner / purchase product
site_version - version of the site (mobile or desktop)
time - time of the action
title - type of event (show, click or purchase)
target - target class - 1 or 0

