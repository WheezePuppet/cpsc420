#Tragedy of the Commons
#Thomas Lackert
cows.tragedy.sim <- function(
  sim.length = 50, # weeks
  farmers = 10, #number of farmers using the pasture
  init.cows = 2, #starting cows
  init.food = 500, #starting food
  grass.growth.rate = .2, #rate at which grass regrows
  decision.ratio = 3 #number able to be supported over number of cows
  ) {
  
  delta.t <- 1
  time <- seq(0,sim.length,delta.t)
  #initials
  cattle <- vector(length=length(time))#Number of cattle on pasture
  cattle[1] <- init.cows*farmers
  foods <- vector(length=length(time))#amount of available grass on pasture measured in number of 
                                      #cows able to be supported for a week
  foods[1] <- init.food
  sustainability <- vector(length=length(time))#how much the pasture can support. 
                                    #i.e. 1 = just enough cows, 2 = twice as many, 0.75 = too many cows
  sustainability[1] <- foods[1]/cattle[1]
  
  for(i in 2:length(time)){
    sustainability[i] = foods[i-1]/cattle[i-1]
    if(sustainability[i] > decision.ratio){
      cows.delta = farmers*1
    }else if(sustainability[i] == decision.ratio){
      cows.delta = 0
    }else if(sustainability[i] == 0){
      cows.delta= -1*(cattle[i-1]*.5)
    }else{
      cows.delta = ((1-(foods[i-1]/cattle[i-1]))*cattle[i-1])*-1
    }
    grass.delta = -cattle[i-1]
  
    cattle[i] = cattle[i-1] + cows.delta
    foods[i] = max((foods[i-1] + (foods[i-1]*grass.growth.rate) + grass.delta), 0)
  }
  return(data.frame(time=time,cows=cattle, grass=foods))
}
plot.cows.tragedy.plot<-function(sim.results){
  all.values <- c(sim.results$grass, sim.results$cows, 0)
  cat(sim.results$grass)
  plot(sim.results$time, sim.results$grass,type="l",col="green",lwd=2,
     ylim=c(min(all.values),max(all.values)),
     main="Tragedy of the Commons",
     xlab="weeks",
     ylab="Food/Cows")
  lines(sim.results$time,sim.results$cows,col="blue",lwd=2)
  legend("topright",fill=c("green","blue"),legend=c("Grass","Cows"))
}