#Zombie apocalypse wall deffense 
#One blade, four guards, four walls, lots of zombies
#Biran Will 
#Version 1
#2-23-16
zombie.sim <- function(dullness.rate = .003, #health/zombie 
                       damage.rate = 2, #health/day per zombie 
                       walkers.per.day.wall1 = 4, #zombie/day 
                       kill.rate.wall1 = .8,  #zombie/day
                       rebuild.rate.wall1 = 3, #health/day
                       walkers.per.day.wall2 = 3, #zombies/day
                       kill.rate.wall2 = .8,  #zombie/day
                       rebuild.rate.wall2 = 2, #health/day
                       walkers.per.day.wall3 = 4, #zombie/day
                       kill.rate.wall3 = .8,  #zombie/day
                       rebuild.rate.wall3 = 4, #health/day
                       walkers.per.day.wall4 = 6, #zombie/day
                       kill.rate.wall4 = .5,  #zombie/day
                       rebuild.rate.wall4 = 7, #health/day
                       sim.time = 365 ) { #day
  # Set up time. (delta.t and time vector).
  delta.t <- 1   #days 
  time <- seq(1, sim.time*4, delta.t)
  # itot() and ttoi() functions (if desired).
  itot <- function(i) (i-1)*delta.t + 0
  ttoi <- function(t) (t-0)/delta.t + 1
  
  # Stocks. (Create a vector and an initial condition for each.)
  wall1 <- vector(length=length(time)); 
  wall1[1] <- 100 #damage 
  wall2 <- vector(length=length(time)); 
  wall2[1] <- 100 #damage 
  wall3 <- vector(length=length(time)); 
  wall3[1] <- 100 #damage 
  wall4 <- vector(length=length(time)); 
  wall4[1] <- 100 #damage 
  blade <- vector(length=length(time)); 
  blade[1] <- 100 #sharpness 
  kills <- vector(length=length(time)); 
  kills <- 0 #sharpness 
  # Simulation loop. 
  # For each slice of simulated time,
  for (i in 2:length(time)){ 
    # Compute the values of all the flows, based on previous stock values.
    walker.deaths.w1 <- walkers.per.day.wall1 * (kill.rate.wall1 * blade[i-1]/blade[1])
    attacking.walkers.w1 <- walkers.per.day.wall1 - walker.deaths.w1 
    
    walker.deaths.w2 <- walkers.per.day.wall2 * (kill.rate.wall2 * blade[i-1]/blade[1])
    attacking.walkers.w2 <- walkers.per.day.wall2 - walker.deaths.w2 
    
    walker.deaths.w3 <- walkers.per.day.wall3 * (kill.rate.wall3 * blade[i-1]/blade[1])
    attacking.walkers.w3 <- walkers.per.day.wall3 - walker.deaths.w3 
    
    walker.deaths.w4 <- walkers.per.day.wall4 * (kill.rate.wall4 * blade[i-1]/blade[1])
    attacking.walkers.w4 <- walkers.per.day.wall4 - walker.deaths.w4 
    
    walker.deaths <- walker.deaths.w1 + walker.deaths.w2 + walker.deaths.w3 + walker.deaths.w4
    
    dullness <- walker.deaths * dullness.rate 
    
    damage.wall1 <- attacking.walkers.w1 * damage.rate  
    damage.wall2 <- attacking.walkers.w2 * damage.rate 
    damage.wall3 <- attacking.walkers.w3 * damage.rate 
    damage.wall4 <- attacking.walkers.w4 * damage.rate 
    
    # Compute the values of all the derivatives of the stocks ("primes").
    wall1.prime <- rebuild.rate.wall1 - damage.wall1 
    wall2.prime <- rebuild.rate.wall2 - damage.wall2 
    wall3.prime <- rebuild.rate.wall3 - damage.wall3 
    wall4.prime <- rebuild.rate.wall4 - damage.wall4 
    blade.prime <- dullness
    # Compute all the new stock values (including any derived stocks).
    if((wall1[i-1] > 0) && (wall2[i-1] > 0) && (wall3[i-1] > 0) && (wall4[i-1] > 0)){ 
      wall1[i] <- max(min(wall1[i-1] + wall1.prime, 100), 0)
      wall2[i] <- max(min(wall2[i-1] + wall2.prime, 100), 0)
      wall3[i] <- max(min(wall3[i-1] + wall3.prime, 100), 0)
      wall4[i] <- max(min(wall4[i-1] + wall4.prime, 100), 0)
      blade[i] <- max((blade[i-1] - dullness), 0)
      kills[i] <- walker.deaths
    }
    else{ 
      wall1[i] <- wall1[i-1]
      wall2[i] <- wall2[i-1]
      wall3[i] <- wall3[i-1]
      wall4[i] <- wall4[i-1]
      blade[i] <- blade[i-1]
      kills[i] <- 0
    }
  } 
  results = data.frame(wall1 = wall1, wall2 = wall2, wall3 = wall3, wall4 = wall4, blade = blade, kills = kills, time = time)
  return (results)
}

#r <- zombie.sim() 
# Plot and analyze.
plot.zombie <- function(r) { 
  all.values <- c(r$wall1, r$blade, r$wall2, r$wall3, r$wall4, 0)
  plot(r$time,r$wall1,type="l",col="brown",lwd=2,
     ylim=c(min(all.values),max(all.values)),
     main="Zombie apocalypse",
     xlab="day",
    ylab="health")
    lines(r$time,r$blade, type="l", col="black", lty="solid", lwd=2)
    lines(r$time,r$wall2, type="l", col="green", lty="solid", lwd=2)
    lines(r$time,r$wall3, type="l", col="red", lty="solid", lwd=2)
    lines(r$time,r$wall4, type="l", col="yellow", lty="solid", lwd=2)
    legend("topright",fill=c("black","green", "red", "yellow", "brown"),legend=c("Blade health","wall 1 health", "wall 2 health", "wall 3 health", "wall 4 health"))
} 
plot.zombie.kills <- function(r) {
  kill.values <- c(r$kills, r$blade, 0)
 plot(r$time,r$kills,type="l",col="red",lwd=2,
     ylim=c(min(kill.values),max(kill.values)),
    main="Camp Daily Kils",
   xlab="day",
  ylab="Kills")
  lines(r$time, r$blade, type="l", col="black", lty="solid", lwd=2)

}
