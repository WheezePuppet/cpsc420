# Meadows "System Trap" modeling 
# The Tragedy of the Commons
# A Population and it's Required Non-Renewable Resources
# CPSC 420 -- spring 2016
# Simulation created by Michael Pokorny

tOfCommons.sim <- function(
  init.population=3e9,
  init.resources=10e9,
  init.new.resources=25e9,
  birth.rate=.04,
  death.rate=.02,
  year.new.resources=100,
  year.start=2000,
  year.end=2400,
  regulation.rate.R=0,
  regulation.rate.N=.045
) {

  #rm(list=ls())

  # Set up time.
  delta.t <- 1   # years
  time <- seq(year.start,year.end,delta.t)  # years from a start year to an end year
  
    #Set up initial values

    P <- vector()                                 # Population
    R <- vector()                                 # Initial Resource
    N <- vector()                                 # Descovered Resource
  
    # Initial conditions.
    P[1] <- init.population                       
    R[1] <- init.resources                        
    N[1] <- init.new.resources                    
  
    # Simulate.
    for (i in 2:length(time)) {
      # Compute flows.
      R.prime = 0
      N.prime = 0
    
      if(i < year.new.resources) {
        amount.per.person <- R[i-1]/P[i-1]                                                              # tons/person
        percent.taken <-.05                                                                             # tons/person
        amount.effect <- ((1 - amount.per.person) * percent.taken) - regulation.rate.R                  # tons/(tons/person)/year
        logistic.factor <- 1 - P[i-1] / (P[i-1] + R[i-1])
      
        if(amount.effect > 0 || is.nan(amount.effect)) {
          R.prime <- 0 - amount.effect * P[i-1]                                                         # tons/year
          P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect)) * logistic.factor    # people/year
        }
        else {
          R.prime <- amount.effect * P[i-1]                                                             # tons/year
         P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect)) * logistic.factor    # people/year
        }
    
        if(R[i-1] == 0) {
          P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect + regulation.rate.R))  # people/year
        }
      }
      else{ 
        amount.per.person <- N[i-1]/P[i-1]                                                              # tons/person
        percent.taken <-.05                                                                             # tons/person
        amount.effect <- ((1 - amount.per.person) * percent.taken) - regulation.rate.N                  # tons/(tons/person)/year
        logistic.factor <- 1 - P[i-1] / (P[i-1] + N[i-1])
      
        if(amount.effect > 0 || is.nan(amount.effect)) {
          N.prime <- 0 - amount.effect * P[i-1]                                                         # tons/year
          P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect)) * logistic.factor    # people/year
        }
        else {
          N.prime <- amount.effect * P[i-1]                                                             # tons/year
          P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect)) * logistic.factor    # people/year
        }
      
        if(N[i-1] == 0) {
          P.prime <- (P[i-1] * birth.rate - P[i-1] * (death.rate + amount.effect + regulation.rate.N))  # people/year
        }
      }
    
      # Compute stocks.
      P[i] <- P[i-1] + P.prime * delta.t                                                                # people    
      R[i] <- R[i-1] + R.prime * delta.t                                                                # tons
      N[i] <- N[i-1] + N.prime * delta.t                                                                # tons  
    
      P[P<0] <- 0
      R[R<0] <- 0
      N[N<0] <- 0

    }
  return(data.frame(time=time,P=P,R=R,N=N))

} # end tOfCommons.Sim

  # Plot results.
plot.TOfCommons.sim <- function(sim.results) {
  all.values <- c(sim.results$P,sim.results$R,sim.results$N)
  par(mar=c(6,6,6,4), las=1, bty="n")
  plot(sim.results$time,sim.results$P,type="l",col="orange",lwd=2,
       ylim=c(0,max(all.values+1e10)),
       xlim=c(sim.results$time[1],max(sim.results$time)),
       main=paste("Population and the Tragedy of the Commons"),
       xlab="Year",
       ylab="Level (in Billions of Units)",
       xaxt = "n",
       yaxt = "n"
  )
  pts = seq(sim.results$time[1],max(sim.results$time),50)
  axis(1, at = pts, labels = paste(pts, sep = ""))
  pts = seq(0,max(all.values+1e10),2e9)
  axis(2, at = seq(0,max(all.values+1e10),2e9), labels = paste(pts/1e9, sep = ""))
  abline(h=seq(0,max(all.values+1e10),1e9), v=seq(sim.results$time[1],max(sim.results$time),25), col="grey", lty="dotted")
  
  lines(sim.results$time,sim.results$R,col="blue",lwd=1)#,lty="b")
  lines(sim.results$time,sim.results$N,col="brown",lwd=1)#,lty="b")

  legend("topleft", c("Population","Initial Resource","Descovered Resource"),
         lty = c(1,1,1), lwd=c(2), col=c("orange","blue","brown"), cex=0.85, bty="y", xjust=1, seg.len=1.5)
}
