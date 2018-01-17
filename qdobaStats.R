
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
arrival.rate <- 4    # customers/min

num.mins.open <- 8*60 # min
#num.mins.open <- 10

sim.clock <- 0       # min

next.service <- Inf
roll.new.arrival.time()

num.served <- 0
max.line.size <- 0
total.line.size <- 0
total.server.state <- 0
arrival.times <- vector()
total.time.in.line <- 0

while (sim.clock < num.mins.open  ||  server.state == BUSY) {

    total.line.size <- total.line.size +
        (min(c(next.arrival,next.service)) - sim.clock) * num.in.line
    total.server.state <- total.server.state +
        (min(c(next.arrival,next.service)) - sim.clock) * server.state

    if (next.arrival < next.service) {
            
        sim.clock <- next.arrival
        cat("Customer arrives at time ", round(sim.clock,2), ".\n",sep="")
        arrival.times <- c(arrival.times, sim.clock)

        if (server.state == IDLE) {
            cat("  Step right up!\n")
            server.state <- BUSY
            roll.new.service.time()
        } else {
            cat("  Customer gets in line. (line now ", (num.in.line+1), ".)\n",
                sep="")
            num.in.line <- num.in.line + 1
            if (num.in.line > max.line.size) {
                max.line.size <- num.in.line
            }
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
        num.served <- num.served + 1
        total.time.in.line <- total.time.in.line + 
            (sim.clock - arrival.times[1])
        arrival.times <- arrival.times[-1]
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

cat("*** It's quittin' time! (", round(sim.clock,2), ")\n\n", sep="")

cat("We served ", num.served, " customers.\n", sep="")
cat("The longest line was ", max.line.size, ".\n", sep="")
cat("The average line size was ", round(total.line.size / sim.clock,2),
     ".\n", sep="")
cat("The server was on his feet ", 
    round(total.server.state / sim.clock * 100,2), "% of the time.\n", sep="")
cat("The average customer delay was ", 
    round(total.time.in.line / sim.clock,2), " mins.\n", sep="")
