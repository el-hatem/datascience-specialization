source('./assignment1.r')


df <- load(directory='./specdata/', id=1:332) 

# pollutantmean(df, pollutant='nitrate')

# complete(df)

# RNGversion("3.5.1")  
# set.seed(42)
# cc <- complete(df)
# use <- sample(332, 10)
# print(cc[use, "nobs"])

# corr(df, 150)

# cr <- corr(df, 2000)                
# n <- length(cr)                
# cr <- corr(df, 1000)                
# cr <- sort(cr)
# print(c(n, round(cr, 4)))


base::rm(list=ls())

