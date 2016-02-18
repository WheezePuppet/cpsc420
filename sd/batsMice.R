
# Shiflet 4.2 -- Lotka-Volterra predator/prey model

# Set up time. (delta.t and time vector).
delta.t <- 1/30 # months
time <- seq(0,240,delta.t)

# itot() and ttoi() functions (if desired).
itot <- function(i) (i-1)*delta.t + 0
ttoi <- function(t) (t-0)/delta.t + 1

# Simulation parameters (inputs).
bat.birth.rate <- 1.2    # (bats/month)/bat
bat.death.rate <- 1.5    # (bats/month)/bat
mouse.birth.rate <- 1.2  # (mice/month)/mouse
mouse.death.rate <- 1.1  # (mice/month)/mouse
nutrition.factor <- 2    # bats/kill
kill.ratio <- 0.05       # kills/encounter
encounter.freq <- .02    # (encounters/month)/bat*mouse
mice.per.kill <- 1       # mice/kill

# Stocks. (Create a vector and an initial condition for each.)
M <- vector(length=length(time))
M[1] <- 200
B <- vector(length=length(time))
B[1] <- 15

# Simulation loop. 
# For each slice of simulated time,
for (i in 2:length(time)) {

    # Compute the values of all the flows, based on previous stock values.
    mouse.births <- mouse.birth.rate * M[i-1]
    bat.births <- bat.birth.rate * B[i-1]

    encounter.rate <- encounter.freq * M[i-1] * B[i-1]   # enc/month
    kill.rate <- kill.ratio * encounter.rate             # kill/month

    bat.deaths <- bat.death.rate * B[i-1] - nutrition.factor * kill.rate
    mouse.deaths <- mouse.death.rate * M[i-1] + kill.rate * mice.per.kill

    # Compute the values of all the derivatives of the stocks ("primes").
    M.prime <- mouse.births - mouse.deaths
    B.prime <- bat.births - bat.deaths

    # Compute all the new stock values (including any derived stocks).
    M[i] <- M[i-1] + M.prime * delta.t
    B[i] <- B[i-1] + B.prime * delta.t
}

# Plot and analyze.
all.vals <- c(M,B,0)
plot(time,M,type="l",col="black",lwd=2,
    ylim=range(all.vals), xlab="time (months)", main="Bats vs. mice")
lines(time,B,col="red",lwd=3)
legend("topleft",fill=c("black","red"),legend=c("mice","bats"))

cat("The bats got as low as",min(B),"\n")
cat("The mice got as low as",min(M),"\n")
