
# Qdoba line Discrete Event Simulation
# CPSC 420 -- spring 2016

IDLE <- 0
BUSY <- 1

cat0 <- function(...) {
    cat(...,sep="")
}

server.state <- IDLE
num.in.line <- 0

sim.clock <- 0

num.mins.open <- 1000

arrival.rate <- 1    # cust/min
service.rate <- .2    # cust/min

next.arrival <- rexp(1, arrival.rate)
next.service <- Inf

while (sim.clock <= num.mins.open  ||  server.state == BUSY) {

    sim.clock <- min(c(next.arrival, next.service))

    if (next.arrival < next.service) {
        cat0("A customer arrived at ", sim.clock, ".\n")
        # The next event to happen is an arrival.
        if (server.state == BUSY) {
            num.in.line <- num.in.line + 1   
            cat0("  Had to get in line. :( (line is now ", num.in.line,
                " long.)\n")
        } else {
            cat("  Step right up!\n")
            server.state <- BUSY            
            next.service <- sim.clock + rexp(1, service.rate)
        }
        if (sim.clock <= num.mins.open) {
            next.arrival <- sim.clock + rexp(1, arrival.rate)
        } else {
            cat("Sorry, bub, we're closed!!\n")
            next.arrival <- Inf
        }
    } else {
        cat0("A customer got served at ", sim.clock, ".\n")
        # The next event to happen is a service.
        if (num.in.line > 0) {
            cat0("  The line advances! It now has ", num.in.line, 
                " people in it.\n")
            num.in.line <- num.in.line - 1
            next.service <- sim.clock + rexp(1, service.rate)
        } else {
            cat("  Whew! Get to sit down finally!\n")
            server.state <- IDLE
            next.service <- Inf
        }
    }
}

cat("It's now quittin' time!\n")
