
library(doParallel)
registerDoParallel(8)

force.regenerate.results <- FALSE
time.delay.animation <- .1         # seconds

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

# Simulation loop. Only generate these time-consuming results if have to or
# we're explicitly instructed to.
if (!exists("grand.results")  ||  force.regenerate.results) {

  # Remember what time this started, just so we can brag about our performance
  # by running in parallel.
  first <- proc.time()

  grand.results <- 
    foreach (mouse.birth.rate = seq(1,2,.005), .combine=rbind) %dopar% {

        one.birth.rate.results <- data.frame()
        for (nutrition.factor in seq(0,5,.1)) {
            for (i in 2:length(time)) {

                mouse.births <- mouse.birth.rate * M[i-1]
                bat.births <- bat.birth.rate * B[i-1]

                encounter.rate <- encounter.freq * M[i-1] * B[i-1] # enc/month
                kill.rate <- kill.ratio * encounter.rate           # kill/month

                bat.deaths <- bat.death.rate * B[i-1] - 
                    nutrition.factor * kill.rate
                mouse.deaths <- mouse.death.rate * M[i-1] + 
                    kill.rate * mice.per.kill

                M.prime <- mouse.births - mouse.deaths
                B.prime <- bat.births - bat.deaths

                M[i] <- M[i-1] + M.prime * delta.t
                B[i] <- B[i-1] + B.prime * delta.t
            }
            one.birth.rate.results <- rbind(one.birth.rate.results, 
                data.frame(mouse.birth.rate=mouse.birth.rate,
                           nutrition.factor=nutrition.factor,
                    min.bats=min(B),
                    min.mice=min(M)))
        }
        return(one.birth.rate.results)
    }

  # Print the elapsed time (current time minus what it was when we started).
  print(proc.time() - first)
}

# (Relabel data frame rows because it's just too annoying otherwise.)
rownames(grand.results) <- 1:nrow(grand.results)


# Plot as an animation. Each frame of the animation corresponds to a
# particular value of mouse.birth.rate, and plots nutrition.factor vs. our two
# population minima (mice, and bats).
for (mouse.birth.rate in unique(grand.results$mouse.birth.rate)) {

    # Get just the results for the current mouse.birth.rate.
    the.results <- 
        grand.results[grand.results$mouse.birth.rate == mouse.birth.rate,]

    # Plot our two dependent variables (simulation outputs) versus our
    # simulation parameter (simulation input). Use a constant ylim so the axes
    # scales don't change from frame to frame, which would confuse us.
    plot(the.results$nutrition.factor,the.results$min.bats,type="l",
        col="red",lwd=2,
        ylim=c(0,50), xlab="nutrition.factor (bats/kill)",
        main=paste("Bats vs. mice: mouse.birth.rate=",mouse.birth.rate))
    lines(the.results$nutrition.factor,the.results$min.mice,col="black",
        lwd=2)
    legend("topleft",fill=c("black","red"),legend=c("mice","bats"))

    # Delay between animation frames.
    Sys.sleep(time.delay.animation)
}

