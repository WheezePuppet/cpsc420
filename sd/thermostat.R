
# Thermostat (Meadows ch.2) -- version 1.0
# (one stock with competing balancing loops)
# CPSC 420 -- spring 2016


# Set up time. (delta.t and time vector).
delta.t <- 1/60              # hrs
starting.time <- 0
time <- seq(starting.time,24*7,delta.t)  # hrs

# itot() and ttoi() functions (if desired).
itot <- function(i) (i-1)*delta.t + starting.time
ttoi <- function(t) (t-starting.time)/delta.t + 1

# Simulation parameters (inputs).
thermostat <- 75     # degF
heating.rate <- 6    # degF/hr

# Cyclical temperature pattern with some random noise.
outside <- sin(2*pi*time/24) * 20 + 35 + rnorm(length(time), mean=0, sd=20)

# 2-hour long smallish reverse nuclear explosion at Wednesday noon
outside[ttoi(3*24+12):ttoi(3*24+14)] <- -400

ins.loss.rate <- .05  # (degF/hr)/degF
hysteresis.factor <- 1 # degF

# Stocks. (Create a vector and an initial condition for each.)
room.temp <- vector(length=length(time))
room.temp[1] <- outside[1]
furnace.on <- vector(length=length(time))
furnace.on[1] <- FALSE

# Simulation loop. 
# For each slice of simulated time,
for (i in 2:length(time)) {

    # Compute the values of all the flows, based on previous stock values.
    # neg value = room too cold for humans to be happy
    discrepancy.thermo <- room.temp[i-1] - thermostat   # degF
    if (furnace.on[i-1]) {
        # Furnace is already on! Don't turn off unless pretty hot.
        if (discrepancy.thermo < hysteresis.factor) {
            furnace.heating <- heating.rate                 # degF/hr
            furnace.on[i] <- TRUE
        } else {
            furnace.heating <- 0
            furnace.on[i] <- FALSE
        }
    } else {
        # Furnace is off. Don't turn on unless pretty cold.
        if (discrepancy.thermo < -hysteresis.factor) {
            furnace.heating <- heating.rate                 # degF/hr
            furnace.on[i] <- TRUE
        } else {
            furnace.heating <- 0
            furnace.on[i] <- FALSE
        }
    }

    # neg value = colder inside than out
    discrepancy.outside <- room.temp[i-1] - outside[i-1]     # degF
    leakage <- ins.loss.rate * discrepancy.outside      # degF/hr

    # Compute the values of all the derivatives of the stocks ("primes").
    room.temp.prime <- furnace.heating - leakage        # degF/hr

    # Compute all the new stock values (including any derived stocks).
    room.temp[i] <- room.temp[i-1] + room.temp.prime * delta.t
}

# Plot and analyze.
all.values <- c(outside,room.temp,thermostat)
plot(time/24,room.temp,type="l",col="red",lwd=2,
    xlab="days",ylab=~degree~F,main="Temperature over time",
    ylim=range(all.values))
abline(h=thermostat,lty="dashed",col="black")
lines(time/24,outside,lty="dotted",lwd=.5,col="blue")

cat("Btw, the furnace was on ", sum(furnace.on)/length(furnace.on)*100,
    "% of the time.\n",sep="")
