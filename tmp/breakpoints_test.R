library(strucchange)
library(bfast)

# Make a time series with two breaks as toy example
data <- ts(c(1:50,-50:20,-100:1), frequency = 10)
plot(data, xlab = 'Time', ylab = 'Variable')


# Convert the time series object into a dataframe, needed for the breakpoints function
order = 3
lag = NULL
slag = NULL
na.action = na.omit
stl = "none"
datapp <- bfastpp(data, order = order, lag = lag, slag = slag,
                  na.action = na.action, stl = stl)

# Find breaks in the regression using the breakpoints function with a maximum of 5 breakpoints.
# The breakpoints function will look for the number of breakpoints with the best fit, so it will not necessary provide an output with 5 breaks). 
bp5 <- breakpoints(response ~ trend, breaks = 5, data = datapp)##, breaks = nbrks

# summary
# The function showed that the BIC was minimum for 4 breaks, which is in my opinion a bit strange given that there are very obviously 2 breaks.
# Indeed, looking at the summary of the BIC scores for each potential number of breaks, the BIC is minimal for 4 breaks. 
# Yet, BIC decreases most for 2 breaks. It thus tends to overestimate the breaks in a time series. 
# I guess I can avoid this by using a h parameter (setting minimum time between two breaks), yet setting a h parameter might be suboptimal for our application as this might affect the modeling of time series with fast recovery times.
bp5$breakpoints # selected breakpoint solution with lowest BIC
summary(bp5) # overview of fits for varying number of breakpoints
plot(bp5)# plot of BIC with varying number of breakpoints
plot(seq(0,1,length.out=223),as.numeric(data), type='l', xlab = 'Time', ylab = 'Variable'); lines(bp5, col = 'red') # plot of solution with lowest BIC
