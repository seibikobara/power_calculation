
library(tidyverse)




# this is the data that we calculate sample size/power based on
s24wt = c(0.75, 0.7, 0.6,0.6,0.6, 0.55, 0.4, 0.35, 0.25, 0.15, 0.15, 0.1, 0.01,0.01,0.01,0.01)
s24ko = c(0.75, 0.6, 0.45,0.45, 0.25,0.25,0.2,0.20, 0.19, 0.18,0.18, 0.1,0.1, 0.05, 0.02,0.02)

# function of monte carlo for 1000 times for each samples size
sims = function(s24wt, s24k){
    set.seed(1000)
    pvals = c()
    powers = c()
    # sample size
    n = seq(6,500,5)
    for(i in n){
        pval_temp = c() 
        for ( j in 1:1000){
            ko = sample(s24ko, i,  replace = TRUE)
            wt = sample(s24wt, i , replace = TRUE)
            r = t.test(ko, wt)
            pval_temp = append(pval_temp, r$p.value)
        }
        # mean of p value among 1000 simulations
        pvals = append(pvals, mean(pval_temp))
        # calculate power, which is how many time you identify significant results in 1000 simulations
        power_ = sum(pval_temp<0.05)/length(pval_temp)
        powers = append(powers, power_)
    }

    res = tibble(n = n, pval = pvals, power = powers) 
    return(res)
}

# run simulation
res = sims(s24wt, s24ko)

# final output
# pval
plot1 = res %>% ggplot(aes(n, pval)) + geom_point() + geom_hline(yintercept = 0.05)
# power 
plot2 = res %>% ggplot(aes(n, power)) + geom_point() + geom_hline(yintercept = 0.8)
plot = egg::ggarrange(plot1, plot2)
plot