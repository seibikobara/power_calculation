library(tidyverse)
library(magrittr)
library(pwr)
library(MASS)



# function to calculate the power of ANOVA
give_power_anova = function(n_group, cohenf, n_each_group){
    res = pwr.anova.test(k=n_group, f = cohenf, n = n_each_group, sig.level = 0.05)
    return(res$power)
}

# function to calculate the detectable cohen f
give_f_anova = function(n_group, n_each_group, power = 0.8){
    res = pwr.anova.test(k=n_group, n = n_each_group, f = NULL, sig.level = 0.05, power = power)
    return(res$f)
}


# function to calulate the power of t-test with equal variance
give_power_ttest = function(cohend, n_each_group){
    res = power.t.test(d = cohend, n = n_each_group, sig.level = 0.05)
    return(res$power)
}


# function to calulate the power of t-test with equal variance
give_d_ttest = function(n_each_group, power = 0.8, alpha=0.05){
    res = power.t.test(n = n_each_group, delta=NULL, power = power, sig.level = alpha,type = c("two.sample"))
    return(res$delta)
}

give_combination = function(n){
    ncol(combn(n, 2))
}


# AIM1
# simulation
# ANOVA
# total sample: 42525
# attrition 15%

phenos = c("A","B","C","D")
phenos_p = c(0.312, 0.508, 0.124, 0.055)
total
# detectable cohen's f for anova
# detectable cohen's d for pair-wise ttest
# Tukey adjusted needs data.
# instead used bonferroni correction
# adjusted alpha in bonferroni

expand_grid(pheno = phenos)  %>% 
    rowwise() %>%
    mutate(n_group = 4) %>% 
    mutate(total_n = 42525) %>% 
    mutate(pheno_p = ifelse(pheno=="A", phenos_p[1],
                     ifelse(pheno=="B", phenos_p[2],
                     ifelse(pheno=="C", phenos_p[3],phenos_p[4])))) %>% 
    mutate(n_each_group = round(total_n * pheno_p)) %>% 
    group_by(n_group) %>% 
    summarise(available_sample_size = min(n_each_group)) %>% 
    ungroup() %>% 
    mutate(f_anova = give_f_anova(n_group, available_sample_size))



expand_grid(pheno = phenos)  %>% 
    rowwise() %>%
    mutate(n_group = 4) %>% 
    mutate(total_n = 800) %>% 
    mutate(pheno_p = ifelse(pheno=="A", phenos_p[1],
                     ifelse(pheno=="B", phenos_p[2],
                     ifelse(pheno=="C", phenos_p[3],phenos_p[4])))) %>% 
    mutate(n_each_group = round(total_n * pheno_p)) %>% 
    group_by(n_group) %>% 
    summarise(available_sample_size = min(n_each_group)) %>% 
    ungroup() %>% 
    mutate(f_anova = give_f_anova(n_group, available_sample_size))















# check moderate and large VFD across clusters can be feasible?
# Bellani, Giacomo, et al. "Epidemiology, patterns of care, and mortality for patients with acute respiratory distress syndrome in intensive care units in 50 countries." Jama 315.8 (2016): 788-800.
# for severe ARDS, VFD is 0 [0-18], median[IQR]
give_median_iqr = function(x){
    res = quantile(x, c(0.25, 0.5, 0.75))
    median = res[2]
    Q1 = res[1]
    Q3 = res[3]
    return(c(median, Q1, Q3))
}
give_mean_sd = function(x){
    mean = mean(x)
    sd = sd(x)
    return(c(mean, sd))
}
# for severe
x = rbeta(n = 557, shape1 = 0.1, shape2=0.25)*28
hist(x)
give_median_iqr(x)
#            50%           25%           75% 
#   0.2770767706  0.0003978028 12.3237037864 
give_mean_sd(x)
# 6.971138 10.249761


# for moderate
x = rbeta(n = 1106, shape1 = 0.1, shape2=0.25)*28
hist(x)
give_median_iqr(x)
#          50%           25%           75% 
# 0.6138640582  0.0004136801 18.2134267134 
give_mean_sd(x)
#  8.083346 10.950025



# so, assuming the observed mean will be the median, Sd will be 10.
# assuming that in the severe group, VFD=0 (10), moderate group: VFD=11 (10).
cohensd = (11-0)/10
cohensd 
# 1.1
# assuming that in the moderate group, VFD=11 (10), mild group: VFD=16 (10).
cohensd = (16-11)/10
cohensd 
# 0.5

# conclusion
# if cluster solution can detect severe, moderate, mild cases, expected effect size is >0.5.
# thus, sample size 200 can reasonably detect the phenotypic difference across clusters.








