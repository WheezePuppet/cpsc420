
# Meadows ch.2 Car dealership example (Fig. 29) -- version 1.0
# no delays (perception, response, or delivery)
# CPSC 420 -- spring 2016

# Set up time. (delta.t and time vector).
delta.t <- 1   # days
time <- seq(0,30,delta.t)

# itot() and ttoi() functions (if desired).
itot <- function(i) (i-1)*delta.t + 0
ttoi <- function(t) (t-0)/delta.t + 1

# Simulation parameters (inputs).
customer.demand <- .25  # (cars/day)/car  (demand prop. to inventory)
stocking.factor <- 10  # cars/(cars/day)
lot.size <- 200        # cars

orders <- vector()    # cars/day
orders[1] <- 0
sales <- vector()     # cars/day
sales[1] <- 0

# Stocks. (Create a vector and an initial condition for each.)
inventory <- vector(length=length(time))
inventory[1] <- 150

# Simulation loop. 
# For each slice of simulated time,
for (i in 2:length(time)) {

    # Compute the values of all the flows, based on previous stock values.

    sales[i] <- customer.demand * inventory[i-1]
    perceived.sales <- sales[i]   # NO perception delay.

    desired.inventory <- 
        min(lot.size, perceived.sales * stocking.factor)
    discrepancy <- inventory[i-1] - desired.inventory # pos = enough

    # NO response delay.
    orders[i] <- max(0,-discrepancy) / delta.t

    deliveries <- orders[i]   # NO delivery delay.

    # Compute the values of all the derivatives of the stocks ("primes").
    inventory.prime <- deliveries - sales[i]

    # Compute all the new stock values (including any derived stocks).
    inventory[i] <- inventory[i-1] + inventory.prime * delta.t

}

# Plot and analyze.
all.values <- c(0,inventory,orders,sales)
plot(time,inventory,type="l",col="red",lwd=2,ylim=range(all.values),
    xlab="days",ylab="",main="The local car dealership")
lines(time,orders,col="purple",lwd=2)
lines(time,sales,col="darkgreen",lwd=2)
legend("bottomright",fill=c("purple","red","darkgreen"),
    legend=c("orders","inventory","sales"))
