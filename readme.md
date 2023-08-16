# Sample size calculation and power calculation


## Sample size calculation and power analysis in general
- Sample size should be determined with the associated power. For instance, if the power is 1 in a certain case, the sample size is too much, and this sample size is nonsense.
- In general, the sample size is the number of samples when the power is around 0.8.
- Power is the probability of significance when running multiple simulation. So, if we run 10,000 times, and we get a significant result for 10,000*0.8 time, the power is 0.8. And then, we would use the sample size that is used in this simulation.
- In other words, we can run simulations while changing the sample size, and then count how many time you get significance, which is the power.
- please see power_calculation.R


## Sample size calculation for ANOVA test
- Sample size calculation in ANOVA can be performed using existing packages because anova can be parametrizable.
- anova_power_calculation.R


## Sample size calculation for logistic regression
- sample size or power calculation for logistic regression is infeasible because logistic regression is not parametrizable.
- For sample size calculation
  - We can use monte carlo simulation to calculate the minimum required sample size that satisfy the expected model metrics (AUROC, F1, etc...)
  - samplesize_logsitc.ipynb
  - In this code, I created a synthetic data to calculate the sample size. This is important because the data we use to calculate power/sample size need to be independent from the data that we use in our actual analysis. Then, I run logistic regression with different sample size to see what sample size can satisfy our expected model performance.



