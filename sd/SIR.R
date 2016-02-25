
# Simulation of SIR disease transmission model
# Introduction to Computational Science -- Shiflet & Shiflet 
# Module 6.2

# Given parameters describing a population and disease characteristics, return
# a data frame of the populations of susceptibles (S), infecteds (I), and
# recovereds (R) over time.
#
sir.sim <- function(
    infection.rate=.00218,    # 1/people*day (rate per infected per day)
    mean.disease.duration=2,  # days
    init.S=780,               # people (number of people susceptible)
    sim.length=30*3           # days
    ) {

    # Set up our time increment and our vector (array) of time (time) values
    delta.t = .01   # day
    time = seq(0,sim.length,delta.t)

    # Constants
    init.I = 1            # people (number of people infected)
    init.R = 0            # people (number of people recovered)
    recovery.rate <- 1/mean.disease.duration    # 1/day

    # Set up our stock variables and initial conditions.
    S = vector(length=length(time))
    S[1] = init.S
    I = vector(length=length(time))
    I[1] = init.I
    R = vector(length=length(time))
    R[1] = init.R

    # Loop a standard number of times, starting with i=2 since we've already
    # set up the simulation's initial conditions at i=1.
    for (i in 2:length(time)) {

        # Compute flows.
        infection <- S[i-1] * I[i-1] * infection.rate
        recovery <- I[i-1] * recovery.rate

        # Compute primes.
        S.prime = -infection
        R.prime = recovery
        I.prime = infection - recovery

        # Compute stocks.
        S[i] = S[i-1] + S.prime * delta.t
        I[i] = I[i-1] + I.prime * delta.t
        R[i] = R[i-1] + R.prime * delta.t
    }

    return(data.frame(time=time,S=S,I=I,R=R))
}


# Assuming all contacts result in infection, then compute the basic
# reproductive number given the rate of a disease's infection, the number of
# days it lasts on average (before infected individual is either dead or no
# longer susceptible) and the initial number of susceptibles in the
# population.
calculate.reproductive.number <- function(infection.rate,
    mean.disease.duration, init.S) {

    # We're assuming all contacts result in infections, so "transmission rate"
    # (rate of contacts between S's and I's) is the same as "infection rate"
    # (rate of new infections making S's turn into I's.)
    contact.rate <- infection.rate

    # k = contacts per day (of the first I) 
    k <- contact.rate * init.S

    # b = transmission rate -- how often a contact results in an infection
    b <- 1
    
    # D = mean disease duration (days)
    D <- mean.disease.duration

    return(k*b*D)
}
    



# Given the results of sir.sim(), plot the populations over time.
plot.sir <- function(sim.results) {

    all.vals <- c(sim.results$S, sim.results$I, sim.results$R, 0)
    plot(sim.results$time,sim.results$S,type="n",
        xlab="time (days)",ylab="population", ylim=range(all.vals))
    lines(sim.results$time,sim.results$S,lwd=3,lty="solid",col="darkgreen")
    lines(sim.results$time,sim.results$I,lwd=2,lty="solid",col="red")
    lines(sim.results$time,sim.results$R,lwd=2,lty="dashed")
    legend("right",lwd=c(3,2,2),lty=c("solid","solid","dashed"),
        col=c("darkgreen","red","black"), legend=c("S","I","R"))
}
