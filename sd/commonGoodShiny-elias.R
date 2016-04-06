#Tragedy of the Commons
#Email System
#CPSC 420 -- Spring 2016
#Elias Ingea

common.sim <- function(spam.percentage=0.4, 
                       good.percentage=1-spam.percentage, 
                       init.total=100, 
                       init.spam=init.total*spam.percentage, 
                       init.common.good=init.total*good.percentage, 
                       regen.rate=0.05, 
                       rate.of.use=0.04, 
                       sim.length=100) {
    
    #set up time
    delta.t <- 1 #days
    time <- seq(0, sim.length, delta.t)

    Total <- vector()
    Good <- vector()
    Spam <- vector()
    SpammerProfit <- vector()

    #Initial condition
    Good[1] <- init.common.good
    Spam[1] <- init.spam
    Total[1] <- init.total
    #Simulate
    for (i in 2:length(time)) {
        #Compute Flow
     
        Good.prime <- regen.rate * Good[i-1]
        Spam.prime <- rate.of.use * Spam[i - 1]
    
        #Compute Stock
        if(Good[i-1] <= 0) {
            Good[i] = 0
        } else {
             Good[i] <- Good[i-1] + (Good.prime-Spam.prime) * delta.t
        }
        if(Spam[i-1] <= 0) {
            Spam[i] = 0
        } else {
            Spam[i] <- Spam[i-1] + (Spam.prime - Good.prime) * delta.t
        }
    }
    return(list(
        results=data.frame(time=time,Good=Good, Spam=Spam),
        params=list(spam.percentage=spam.percentage, 
                    good.percentage=good.percentage,
                    init.total=init.total, init.spam=init.spam, 
                    init.common.good=init.common.good, 
                    regen.rate=regen.rate, 
                    rate.of.use=rate.of.use, 
                    sim.length=sim.length)))
}
#all.values <- c(Good, Spam)
plot.common.good <- function(sim.results) {
    results <- sim.results$results
    max.y <- max(80,results$Spam+results$Good)
    plot(results$time, results$Good, type="l", col="blue", lwd=2, 
     ylim=c(0, max.y), 
     main="Tragedy of the Commons - Spam Emails",
     xlab="days", 
     ylab="emails")
lines(results$time, results$Spam, col="red", lwd=2)
#lines(time, Total, col="green", lwd=2)
legend("topleft", legend=c("Emails", "Spam"), fill=c("blue", "red"))
}
