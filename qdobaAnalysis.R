library(doParallel)
registerDoParallel(8)


IDLE <- 0
BUSY <- 1

PRINT.STUFF <- TRUE

mycat <- function(...) {
    if (PRINT.STUFF) {
        cat(...)
    }
}


run.qdoba.sim <- function(arrival.rate=2, service.rate=3, num.mins.open=10) {

    server.state <- IDLE
    num.in.line <- 0

    sim.clock <- 0       # min

    next.service <- Inf
    next.arrival <- rexp(1, arrival.rate)

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
            mycat("Customer arrives at time ", round(sim.clock,2), ".\n",
                sep="")
            arrival.times <- c(arrival.times, sim.clock)

            if (server.state == IDLE) {
                mycat("  Step right up!\n")
                server.state <- BUSY
                next.service <- sim.clock + rexp(1, service.rate)
            } else {
                mycat("  Customer gets in line. (line now ", (num.in.line+1), 
                    ".)\n", sep="")
                num.in.line <- num.in.line + 1
                if (num.in.line > max.line.size) {
                    max.line.size <- num.in.line
                }
            }
            if (sim.clock < num.mins.open) {
                next.arrival <- sim.clock + rexp(1, arrival.rate)
            } else {
                mycat("========= no more customers, sorry ==========\n")
                next.arrival <- Inf
            }
        } else {
            sim.clock <- next.service
            mycat("Burrito finished at time ", round(sim.clock,2), ".\n",
                sep="")
            num.served <- num.served + 1
            total.time.in.line <- total.time.in.line + 
                (sim.clock - arrival.times[1])
            arrival.times <- arrival.times[-1]
            if (num.in.line == 0) {
                mycat("  Server takes a load off.\n")
                server.state <- IDLE
                next.service <- Inf
            } else {
                mycat("  Server begins making next burrito. (line now ",
                    (num.in.line-1), ".)\n",sep="")
                num.in.line <- num.in.line - 1
                next.service <- sim.clock + rexp(1, service.rate)
            }
        }
    }
    mycat("*** It's quittin' time! (", round(sim.clock,2), ")\n\n", sep="")

    data.frame(service.rate=service.rate,
        num.served=num.served,
        max.line.size=max.line.size,
        avg.line.size=round(total.line.size / sim.clock,2),
        server.utilization=round(total.server.state / sim.clock * 100,2),
        avg.cust.delay=round(total.time.in.line / sim.clock,2))
}

#results <- run.qdoba.sim(2,3,8*60)
#
#mycat("We served ", results$num.served, " customers.\n", sep="")
#mycat("The longest line was ", results$max.line.size, ".\n", sep="")
#mycat("The average line size was ", results$avg.line.size,
#     ".\n", sep="")
#mycat("The server was on his feet ", 
#    results$server.utilization, "% of the time.\n", sep="")
#mycat("The average customer delay was ", 
#    results$avg.cust.delay, " mins.\n", sep="")

PRINT.STUFF <- FALSE

results <- foreach(service.rate=seq(1,10,.1), .combine=rbind) %dopar% {
    run.qdoba.sim(4,service.rate,8*60)
}

plot.me <- function(service.rates, other.values, title) {
    plot(service.rates, other.values, type="l", main=title,
        ylim=c(0,max(other.values)))
}

for (col in 2:ncol(results)) {
    plot.me(results$service.rate, results[[col]], title=names(results)[col])
    readline()
}
