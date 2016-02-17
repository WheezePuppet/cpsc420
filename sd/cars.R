
# Meadows ch.2 Car dealership example (Fig. 29) -- version 2.0
# response delay parameter sweep
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

delivery.delay <- 1   # days

# Stocks. (Create a vector and an initial condition for each.)
inventory <- vector(length=length(time))
inventory[1] <- 150

# Simulation loop. 
# For each slice of simulated time,
results <- data.frame()
for (response.delay in 0:10) {
    for (i in 2:length(time)) {

        # Compute the values of all the flows, based on previous stock 
        # values.

        sales[i] <- customer.demand * inventory[i-1]
        perceived.sales <- sales[i]   # NO perception delay.

        desired.inventory <- 
            min(lot.size, perceived.sales * stocking.factor)
        discrepancy <- inventory[i-1] - desired.inventory # pos = enough

        orders[i] <- max(0,-discrepancy/(response.delay+1)) / delta.t

        deliveries <- orders[max(1,i-delivery.delay)]

        # Compute the values of all the derivatives of the stocks 
        # ("primes").
        inventory.prime <- deliveries - sales[i]

        # Compute all the new stock values (including any derived 
        # stocks).
        inventory[i] <- inventory[i-1] + inventory.prime * delta.t
    }
    results <- rbind(results,
        list(response.delay=response.delay,
            total.sales=sum(sales),
            inventory.wildness=sd(inventory)
        )
    )
}

# Plot and analyze.
all.vals <- c(results$total.sales, results$inventory.wildness, 0)
plot(results$response.delay, results$total.sales, type="l", col="darkgreen",
    lwd=2, main="Total sales and wildness of inventory vs. response delay",
    xlab="response delay (days)", ylab="", ylim=range(all.vals))
lines(results$response.delay, results$inventory.wildness*10, col="red", lwd=2)
legend("top", fill=c("darkgreen","red"), 
    legend=c("total sales ($)", "10 x Std. dev. of inventory"))
