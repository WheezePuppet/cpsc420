# Jon Blauvelt
# 3/16/16
# escalation.R
# A small simulation to illustrate the escalation system trap
# by way of a nuclear arms race.

# Define function.
escalation.sim <- function(

    # Parameters.
    sim.length = 20,              # years 
    usa.perception.bias =.25,      # unitless (extra warhead/actual warhead)
    ussr.perception.bias = .20,    # unitless (extra warhead/actual warhead)
    usa.desired.advantage = .25,   # unitless (extra warheads/enemy warhead)
    ussr.desired.advantage = .20,  # unitless (extra warheads/enemy warhead)
    usa.correction.period = 1,    # years
    ussr.correction.period = 1,   # years
    prev.results = NULL
){

  # Set up time slices.
  deltaT <- .01  # years

  # Start new sim.
  if(is.null(prev.results)){
    init.usa.stockpile <- 1     
    init.ussr.stockpile <- 0
    init.time <- 0
  
  # Handle continuation of last sim. 
  }else{
    num.rows <- nrow(prev.results)
    init.usa.stockpile <- prev.results[num.rows,"usa.stockpile"]    
    init.ussr.stockpile <- prev.results[num.rows,"ussr.stockpile"]
    init.time <- prev.results[num.rows,"time"]    
  }
  
  # Set up time vector.
  time <- seq(init.time,init.time + sim.length,deltaT)

  # Set up stocks.
  usa.stockpile <- vector(length=length(t))
  usa.stockpile[1] <- init.usa.stockpile
  ussr.stockpile <- vector(length=length(t))
  ussr.stockpile[1] <- init.ussr.stockpile
  
  # Simulation loop.
  for (i in 2:length(time)){

    # Compute flows.
    perceived.usa.stockpile <- 
                usa.stockpile[i-1] * (1 + ussr.perception.bias)

    perceived.ussr.stockpile <- 
                ussr.stockpile[i-1] *(1 + usa.perception.bias)

    usa.warhead.production <- 
              max((perceived.ussr.stockpile * (1 + usa.desired.advantage)) -
              usa.stockpile[i-1], 0)/max(usa.correction.period, deltaT)

    ussr.warhead.production <- 
              max((perceived.usa.stockpile * (1 + ussr.desired.advantage)) -
              ussr.stockpile[i-1], 0)/max(ussr.correction.period,deltaT)

    # Update stocks.
    usa.stockpile[i] <- 
                usa.stockpile[i-1] + usa.warhead.production * deltaT
    ussr.stockpile[i] <- 
                ussr.stockpile[i-1] + ussr.warhead.production *deltaT
  }# End for loop.
  
  # Return the results.
  return(rbind(prev.results,data.frame(time, usa.stockpile,
         ussr.stockpile)))

}# End sim function.

# Plot.
plot.escalation <- function(sim.results){
  
  all.vals <- c(sim.results$usa.stockpile, sim.results$ussr.stockpile)
  
  plot(sim.results$time, sim.results$usa.stockpile, type="l", lwd ="2",
      col="blue", ylim=range(all.vals), xlim=range(sim.results$time), 
      xlab="time (years)", ylab="number of warheads",
      main="Escalation System Trap: A Nuclear Arms Race")

  lines(sim.results$time, sim.results$ussr.stockpile, col="red", lwd="2",
        lty="dashed")

  legend("topleft", fill=c("blue","red"), 
         legend=c("USA stockpile","USSR stockpile"))

}# End plot function.

