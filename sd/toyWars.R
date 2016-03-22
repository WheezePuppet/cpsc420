# Meadows ch.5 "Escalation"
# CPSC 420 -- spring 2016
# Ruth Catlett

# Given parameters describing two children and their deisred to have more toys,
# return a data frame containing its amount of toys they each have over time.
#
# sim.length (weeks)
# brag.rate.childx - the number of toys per toy that a child will inflate their
#       actual amount of toys
# win.rate.childx - the amount of toys/toy that a child wants to have above 
#       what the other seems to have
# allowance - how many dollars a week each child recieves
# cost.of.toy - how much a toy costs, measured in dollars/toy
# makeup.rate.childx - how slowly or quickly a child wants to gain the advantage
#       over the other child, measured in (toys/week)/toys 
# toys.childx - the number of toys a child has at any time interval
# piggy.bank.childx - the amount of money a child has at a time
# childx.bragged.amount - the number of toys a child says they have,
#       the amount they have plus their inflation rate
# desired.amount.childx - the number of toys a child wants to have
# want.to.purchase.childx - how many toys/week the child wants
# purchases.childx - the number of toys a child will buy at a time interval
#

toy.sim <- function(sim.length=2, brag.rate.child1=0, brag.rate.child2=0,
    win.rate.child1=0, win.rate.child2=0, allowance=20, cost.of.toy=5, 
      child1.start=10, child2.start=5, piggy1.start=20, piggy2.start=20) {
  
  # Set up time. (delta.t and time vector)/
  #sim.length <- 2 # week
  delta.t <- 1/7 # week
  time <- seq(0, sim.length, delta.t)
  
  # Simulation parameters (inputs).
  #brag.rate.child1 <- 0 # toy/toys
  #brag.rate.child2 <- 0 # toy/toys
  
  # Adding the chosen percentage
  win.rate.child1 <- 1 + win.rate.child1# toys/toy
  win.rate.child2 <- 1 + win.rate.child2 # toys/toy
  
  #allowance <- 20 # $/week
  #cost.of.toy <- 5 # $/toy
  
  makeup.rate.child1 <- 1 # (toys/week) / toy
  makeup.rate.child2 <- 1 # (toys/week) / toy
  
  # Stocks.
  toys.child1 <- vector(length=length(time)) # toys
  toys.child1[1] <- child1.start # toys
  toys.child2 <- vector(length=length(time)) # toys
  toys.child2[1] <- child2.start # toys
  
  purchases.child1 <- vector(length=length(time)) # toys
  purchases.child1[1] <- 0 # toys
  purchases.child2 <- vector(length=length(time)) # toys
  purchases.child2[1] <- 0 # toys
  
  piggy.bank.child1<- vector(length=length(time)) # $
  piggy.bank.child1[1] <- piggy1.start # $
  piggy.bank.child2<- vector(length=length(time)) # $
  piggy.bank.child2[1] <- piggy2.start # $
  
  for (i in 2:length(time)) {
    # Is it allowance day? Set piggy bank for this round
    if (i %% 7 == 0) {
      piggy.bank.child1[i] <- piggy.bank.child1[i-1] + allowance
      piggy.bank.child2[i] <- piggy.bank.child2[i-1] + allowance
    } else {
      piggy.bank.child1[i] <- piggy.bank.child1[i-1]
      piggy.bank.child2[i] <- piggy.bank.child2[i-1]
    }
    
    child1.bragged.amount <- toys.child1[i-1] + ceiling(brag.rate.child1 * toys.child1[i-1])
    child2.bragged.amount <- toys.child2[i-1] + ceiling(brag.rate.child2 * toys.child2[i-1])
    
    desired.amount.child1 <- child2.bragged.amount * win.rate.child1 # toys
    desired.amount.child2 <- child1.bragged.amount * win.rate.child2 # toys
    
    diff.for.child1 <- max(0, desired.amount.child1 - toys.child1[i-1]) # toys
    diff.for.child2 <- max(0, desired.amount.child2 - toys.child2[i-1]) # toys
  
    want.to.purchase.child1 <- ceiling(makeup.rate.child1 * diff.for.child1) # toys/week
    want.to.purchase.child2 <- ceiling(makeup.rate.child2 * diff.for.child2) # toys/week
    
    purchases.child1[i] <- ceiling(want.to.purchase.child1 * delta.t) # toys
    if (cost.of.toy * want.to.purchase.child1 > piggy.bank.child1[i]) {
      purchases.child1[i] <- floor(piggy.bank.child1[i]/cost.of.toy) # toys
    }
    
    purchases.child2[i] <- ceiling(want.to.purchase.child2 * delta.t) # toys
    if (cost.of.toy * want.to.purchase.child2 > piggy.bank.child2[i]) {
      purchases.child2[i] <- floor(piggy.bank.child2[i]/cost.of.toy) # toys
    }
    
    piggy.bank.child1[i] <- piggy.bank.child1[i] - (purchases.child1[i] * cost.of.toy)
    piggy.bank.child2[i] <- piggy.bank.child2[i] - (purchases.child2[i] * cost.of.toy)
    
    toys.child1[i] <- toys.child1[i-1] + purchases.child1[i]
    toys.child2[i] <- toys.child2[i-1] + purchases.child2[i]
    
  }
  return(data.frame(time=time, child1=toys.child1, child2=toys.child2))
}


# Given the results of toy.sim(), plot the number of toys over time.
plot.toys.time.plot <- function(toy.results) {
  all.values <- c(toy.results$child1, toy.results$child2, 0)
  
  plot(toy.results$time, toy.results$child1, type="l", lty="solid", lwd=3,col="red", main="Toy Wars!", xlab="Weeks", 
       ylab="Toys", ylim=range(all.values), xlim=range(toy.results$time))
  
  lines(toy.results$time, toy.results$child2, type="l", lty="dashed", lwd=2, col="black")
  
  legend("bottomright", lty=rep(c("solid","dashed"),2),
         lwd=c(3,2),
         col=c("red","black"), 
         legend=c("Child 1's Toys", "Child 2's Toys"))
}