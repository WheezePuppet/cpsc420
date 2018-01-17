
roll.new.arrival.time <- function() {
    next.arrival <<- sim.clock + rexp(1, arrival.rate)
}

roll.new.service.time <- function() {
    next.service <<- sim.clock + rexp(1, service.rate)
}

IDLE <- 0
BUSY <- 1

server.state <- IDLE
num.in.line <- 0

service.rate <- 3    # burritos/min
arrival.rate <- 2    # customers/min

num.mins.open <- 8*60 # min
num.mins.open <- 10

sim.clock <- 0       # min

next.service <- Inf
roll.new.arrival.time()


while (sim.clock < num.mins.open  ||  server.state == BUSY) {

    if (next.arrival < next.service) {
        sim.clock <- next.arrival
        cat("Customer arrives at time ", round(sim.clock,2), ".\n",sep="")
        if (server.state == IDLE) {
            cat("  Step right up!\n")
            server.state <- BUSY
            roll.new.service.time()
        } else {
            cat("  Customer gets in line. (line now ", (num.in.line+1), ".)\n",
                sep="")
            num.in.line <- num.in.line + 1
        }
        if (sim.clock < num.mins.open) {
            roll.new.arrival.time()
        } else {
            cat("========= no more customers, sorry ==========\n")
            next.arrival <- Inf
        }
    } else {
        sim.clock <- next.service
        cat("Burrito finished at time ", round(sim.clock,2), ".\n",sep="")
        if (num.in.line == 0) {
            cat("  Server takes a load off.\n")
            server.state <- IDLE
            next.service <- Inf
        } else {
            cat("  Server begins making next burrito. (line now ",
                (num.in.line-1), ".)\n",sep="")
            num.in.line <- num.in.line - 1
            roll.new.service.time()
        }
    }
}

cat("*** It's quittin' time!\n")

