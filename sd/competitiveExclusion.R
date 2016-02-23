
# Meadows ch.5 "Competitive Exclusion" system trap ("The Matthew Effect")
# CPSC 420 -- spring 2016

# Set up time. (delta.t and time vector).
start.year <- 2016  # years
sim.length <- 750   # years
delta.t <- 1/12     # years
time <- seq(start.year,start.year+sim.length,delta.t)

# itot() and ttoi() functions (if desired).
itot <- function(i) (i-1)*delta.t + start.year
ttoi <- function(t) (t-start.year)/delta.t + 1

# Simulation parameters (inputs).
earnings.rate.company1 <- .46    # ($earned/$capital)/year
earnings.rate.company2 <- .45    # ($earned/$capital)/year
investment.frac.company1 <- .3   # ($reinvested/$earned)/year
investment.frac.company2 <- .3   # ($reinvested/$earned)/year
depreciation.rate <- .1          # ($depreciated/$capital)/year
economy.cc <- 10000              # $/year (in earnings) saturation point
earnings.company1 <- 100
earnings.company2 <- 100

# Stocks. (Create a vector and an initial condition for each.)
company1.capital <- vector(length=length(time))    # $
company1.capital[1] <- 100
company2.capital <- vector(length=length(time))    # $
company2.capital[1] <- 100

profits.company1 <- vector(length=length(time))    # $
profits.company1[1] <- 0
profits.company2 <- vector(length=length(time))    # $
profits.company2[1] <- 0

# Simulation loop. 
# For each slice of simulated time,
for (i in 2:length(time)) {

    # Compute the values of all the flows, based on previous stock values.
    logistic.factor <- 
        1 - (earnings.company1 + earnings.company2) / economy.cc
    earnings.company1 <- company1.capital[i-1] * earnings.rate.company1
    earnings.company1 <- earnings.company1 * logistic.factor
    investment.company1 <- earnings.company1 * investment.frac.company1
    profits.company1[i] <- earnings.company1 * (1 - investment.frac.company1)

    earnings.company2 <- company2.capital[i-1] * earnings.rate.company2
    earnings.company2 <- earnings.company2 * logistic.factor
    investment.company2 <- earnings.company2 * investment.frac.company2
    profits.company2[i] <- earnings.company2 * (1 - investment.frac.company2)

    depreciation.company1 <- company1.capital[i-1] * depreciation.rate
    depreciation.company2 <- company2.capital[i-1] * depreciation.rate

    # Compute the values of all the derivatives of the stocks 
    # ("primes").
    company1.capital.prime <- investment.company1 - depreciation.company1
    company2.capital.prime <- investment.company2 - depreciation.company2

    # Compute all the new stock values (including any derived 
    # stocks).
    company1.capital[i] <- company1.capital[i-1] + 
        company1.capital.prime * delta.t
    company2.capital[i] <- company2.capital[i-1] + 
        company2.capital.prime * delta.t
}

# Plot and analyze.
all.vals <- c(company1.capital,company2.capital,profits.company1,
    profits.company2)
plot(time, company1.capital, type="l", col="blue", lty="solid",
    lwd=2, main="Competitive exclusion",
    xlab="year", ylab="$", ylim=range(all.vals))
lines(time, company2.capital, type="l", col="green", lty="solid", lwd=2)
lines(time, profits.company1, type="l", col="blue", lty="dashed", lwd=1)
lines(time, profits.company2, type="l", col="green", lty="dashed", lwd=1)
legend("topleft", lty=c(rep("solid","dashed",2)),
                  lwd=c(rep(2,1),rep(2,1)),
    col=c(rep("blue",2),rep("green",2)), 
    legend=c("Company 1 capital","Company 2 capital",
                                 "Company 1 profits","Company 2 profits"))
