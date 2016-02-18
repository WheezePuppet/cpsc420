
# Shiflet 4.2 -- Lotka-Volterra predator/prey model

# Set up time. (delta.t and time vector).
delta.t <- 1/30 # months
time <- seq(0,240,delta.t)

# itot() and ttoi() functions (if desired).
itot <- function(i) (i-1)*delta.t + 0
ttoi <- function(t) (t-0)/delta.t + 1

# Simulation parameters (inputs).
bat.birth.rate <- 1.2    # (bats/month)/bat
bat.death.rate <- 2.1    # (bats/month)/bat
mouse.birth.rate <- 1.2  # (mice/month)/mouse
mouse.death.rate <- 1.1  # (mice/month)/mouse
nutrition.factor <- 2    # bats/kill
kill.ratio <- 0.05       # kills/encounter
encounter.freq <- .02    # (encounters/month)/bat*mouse

# Stocks. (Create a vector and an initial condition for each.)

# Simulation loop. 
# For each slice of simulated time,

    # Compute the values of all the flows, based on previous stock values.

    # Compute the values of all the derivatives of the stocks ("primes").

    # Compute all the new stock values (including any derived stocks).

# Plot and analyze.
