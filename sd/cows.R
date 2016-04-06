#Hannah Zontine

cows.sim <- function(del=1, acow=25, bcow=35, length=100, ae= 100, be=100, blade=1000,cow.eat.rate=.25, 
	grass.growth.rate=.01, cow.cost=15, A.reinvestment=.15, B.reinvestment=.15,cow.profit=1, blades.per.cow=6, birth=0,
	y=1000) {
  delta=del
  num <- seq(1,length, by=as.numeric(del))
	acows <- vector(length=length(num))
	acows[1] <- acow
	bcows <- vector(length=length(num))
	bcows[1] <- bcow
	total <- vector(length=length(num))
	total[1] <- acows[1] + bcows[1]
	aearn <- vector(length=length(num))
	aearn[1] <- ae
	bearn <- vector(length=length(num))
	bearn[1] <- be
	blades <- vector(length=length(num))
	blades[1] <- blade
	cow.birth <- as.numeric(birth)
	for(i in 2:length(num)){
	  grass.growth <- grass.growth.rate * blades[i-1]         # blades per day
	  grass.feeding <- cow.eat.rate * total[i-1]              # blades per day
	  A.milking <- cow.profit * acows[i-1]                    # dollars/day
	  B.milking <- cow.profit * bcows[i-1]                    # dollars/day
	  A.cow.spending <- A.reinvestment * aearn[i-1] / delta   # dollars/day
	  B.cow.spending <- B.reinvestment * bearn[i-1] / delta   # dollars/day
	  A.cow.purchasing <- A.reinvestment * aearn[i-1] / cow.cost / delta # cows per day
	  B.cow.purchasing <- B.reinvestment * bearn[i-1] / cow.cost / delta # cows per day
	  blades.of.grass.prime <- grass.growth - grass.feeding
	  A.earnings.prime <- A.milking - A.cow.spending    
	  B.earnings.prime <- B.milking - B.cow.spending
	  if(is.na(blades[i-1]) <= is.na(blades.per.cow * total[i-1])){
	    numb <- (blades.per.cow * total[i-1]) - blades[i-1]
	    death.prime <- numb /blades.per.cow / 2
	    if(acows[i-1] < 1){
	      acows[i] = 0
	    }else{
	      acows[i] <- trunc(acows[i-1] - death.prime + (A.cow.purchasing * delta) + (cow.birth * delta))
	    }
	    if(bcows[i-1] < 1){
	      bcows[i] = 0
	    }else{
	      bcows[i] <- trunc(bcows[i-1] - death.prime + (B.cow.purchasing * delta) + (cow.birth * delta))
	    }
	    blades[i] <- trunc(blades[i-1] + blades.of.grass.prime * delta) #cows
	    if(aearn[i-1] <= cow.cost*2){
	      aearn[i] = 0
	    }else{
	      aearn[i] <- aearn[i-1] - (death.prime * cow.cost) + A.earnings.prime * delta
	    }
	    if(bearn[i-1] <= cow.cost*2){
	      bearn[i] = 0
	    }else{
	      bearn[i] <- bearn[i-1] - (death.prime * cow.cost) + B.earnings.prime * delta
	    }
	  }else{
	    if(acows[i-1] < 2){
	      acows[i] = 0
	  }
	    if(bcows[i-1] < 2){
	      bcows[i] = 0
	    }
	    blades[i] <- trunc(blades[i-1] + blades.of.grass.prime * delta) #cows
	    if(aearn[i-1] <= cow.cost *4){
	      aearn[i] = 0
	    }else{
	      aearn[i] <- aearn[i-1] + A.earnings.prime * delta
	    }
	    if(bearn[i-1] <= cow.cost *4){
	      bearn[i] = 0
	    }else{
	      bearn[i] <- bearn[i-1] + B.earnings.prime * delta
	    }
	  }
	  total[i] <- trunc(acows[i] + bcows[i])
	}
	yaxis=max
	return(data.frame(time=num, acow=acows, bcow=bcows, amoney=aearn, bmoney=bearn, grass=blades))

}

plot.cows.sim <- function(sim.results, yaxis){
	plot(sim.results$time, sim.results$acow, type="l", col="cadetblue3",lwd=2, ylim=c(0,yaxis), ylab="", xlab="Days")
  lines(sim.results$time, sim.results$bcow, col="darkorchid3",lwd=2)
  lines(sim.results$time, sim.results$grass, col="green",lwd=2)
  lines(sim.results$time, sim.results$amoney,col="cadetblue3",lwd=2, lty=2)
  lines(sim.results$time, sim.results$bmoney, col="darkorchid2",lwd=2, lty=2)
  legend("topright",legend=c("Farmer A's Cows","Farmer B's Cows", "Blades of Grass", "Farmer A's profit", "Farmer B's profit"),
             fill=c("cadetblue3", "darkorchid3", "green", "cadetblue3", "darkorchid3"), cex=1, lty=c(0,0,0,2,2))
}





