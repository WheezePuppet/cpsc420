#Alex Priest

han.solo.sim <- function(
  init.patrols=100,  # Patrols
  init.contraband=75,    # Shipments
  demand=1000,       # CR/Shipment
  encounter.frequency=.25,    # (encounters/GSD)/patrol*smuggler
  sim.length=240,         # Galactic Standard Days (GSD)
  contract.incentive=.001, # NewSmugglers/credit
  smuggle.rate=1, # Shipments/GSD/Smuggler
  patrol.rate=2, # Patrols/Shipment
  confiscation.ratio=.5, # Shipments/Encounter
  desired.shipments=100 # Shipments
) {
  
  # Set up time. (delta.t and time vector).
  delta.t <- 1 # GSD
  time <- seq(0,sim.length,delta.t)
  
  
  
  # Stocks.
  Smugglers <- vector(length=length(time))
  Smugglers[1] <- 0
  Patrols <- vector(length=length(time))
  Patrols[1] <- init.patrols
  Contraband <- vector(length = length(time))
  Contraband[1] <- init.contraband
  
  # Simulation loop. 
  for (i in 2:length(time)) {
    
    Smugglers[i] <- Contraband[i-1] * demand * contract.incentive # Smugglers
    
    Patrols[i] <- Contraband[i-1] * patrol.rate # Patrols
    
    C.prime <- Smugglers[i] * smuggle.rate * delta.t - Patrols[i] * encounter.frequency * confiscation.ratio
    
    demand = demand * desired.shipments / Contraband[i-1]
    
    Contraband[i] = Contraband[i-1] + C.prime * delta.t
    }
  return(data.frame(time=time,contraband=Contraband))
}

# Given the results, plot the populations over time.
plot.contraband.plot <- function(sim.results) {
  all.vals <- c(sim.results$contraband,0)
  plot(sim.results$time,sim.results$contraband,type="l",col="black",lwd=2,
       ylim=range(all.vals), xlab="time (days)", main="Looks Like We Got Ourselves a Smuggler!")
  # legend("topleft",fill=c("black","red"),legend=c("mice","bats"))
}