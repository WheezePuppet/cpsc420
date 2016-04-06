#Tragedy of the Commons
#Email System
#CPSC 420 -- Spring 2016
#Elias Ingea

#set up time
delta.t <- 1 #days
time <- seq(0, 50, delta.t)

#utility functions to convert between i and t
itot <- function(i) (i - 1)*delta.t
ttoi <- function(i) (t)/delta.t + 1

#Simulation parameters. 
spam.percentage = 0.5                             #total/spam
good.percentage = 1 - spam.percentage               #total/emails
init.total = 100                                    #emails
init.spam = init.total * spam.percentage            #emails
init.common.good = init.total * good.percentage     #emails
init.spammer.profit = 0                             #dollars
regen.rate = 0.05                                   #(emails/day)/email
rate.of.use = 0.04                                  #(emails/day)/email

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
        #Total[i] <- Total[i-1] + (Good.prime + Spam.prime) * delta.t
}
all.values <- c(Good, Spam)
plot(time, Good, type="l", col="blue", lwd=2, 
     ylim=c(min(all.values), max(all.values)), 
     main="Tragedy of the Commons - Spam Emails",
     xlab="days", 
     ylab="emails")
lines(time, Spam, col="red", lwd=2)
#lines(time, Total, col="green", lwd=2)
legend("topleft", legend=c("Emails", "Spam"), fill=c("blue", "red"))
