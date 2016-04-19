
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
service.rate <- 1    # cust/min

next.arrival <- rexp(1, arrival.rate)
next.service <- Inf

total.customers.served <- 0
max.line.size <- 0
time.spent.busy <- 0 
total.cumulative.line.size <- 0

while (sim.clock <= num.mins.open  ||  server.state == BUSY) {

    # Compute the time of the next event.
    time.of.next.event <- min(next.arrival, next.service)

    # How much time has elapsed between the previous event and this one?
    time.since.last.event <- time.of.next.event - sim.clock

    # Compute the height of the rectangles we need to add to our running
    # totals. (This is the state that the server was just in, and the 
    # number of people in line there just were.)
    height.of.util.rectangle <- server.state
    height.of.num.in.line.rectangle <- num.in.line

    # Compute the areas of the rectangles we need to add to our running
    # totals.
    area.of.util.rectangle <- time.since.last.event *
        height.of.util.rectangle
    area.of.num.in.line.rectangle <- time.since.last.event *
        height.of.num.in.line.rectangle

    # Add these areas to our running totals.
    time.spent.busy <- time.spent.busy + area.of.util.rectangle
    total.cumulative.line.size <- total.cumulative.line.size +
        area.of.num.in.line.rectangle
    
    
    # Okay, now that that bookkeeping's out of the way, actually advance the
    # simulation clock.
    sim.clock <- time.of.next.event

    if (next.arrival < next.service) {
        cat0("A customer arrived at ", sim.clock, ".\n")
        # The next event to happen is an arrival.
        if (server.state == BUSY) {
            num.in.line <- num.in.line + 1   
            if (num.in.line > max.line.size) {
                max.line.size <- num.in.line
            }
            cat0("  Had to get in line. :( (line is now ", num.in.line,
                " long.)\n")
        } else {
            cat0("  Step right up!\n")
            server.state <- BUSY            
            next.service <- sim.clock + rexp(1, service.rate)
        }
        if (sim.clock <= num.mins.open) {
            next.arrival <- sim.clock + rexp(1, arrival.rate)
        } else {
            cat0("Sorry, bub, we're closed!!\n")
            next.arrival <- Inf
        }
    } else {
        cat0("A customer got served at ", sim.clock, ".\n")
        total.customers.served <- total.customers.served + 1
        # The next event to happen is a service.
        if (num.in.line > 0) {
            cat0("  The line advances! It now has ", num.in.line, 
                " people in it.\n")
            num.in.line <- num.in.line - 1
            next.service <- sim.clock + rexp(1, service.rate)
        } else {
            cat0("  Whew! Get to sit down finally!\n")
            server.state <- IDLE
            next.service <- Inf
        }
    }
}

cat0("It's now quittin' time!\n")
cat0("We served ", total.customers.served, " customers today!\n")
cat0("The longest the line ever got was: ",max.line.size, ".\n")
cat0("The server was on his feet ", round(time.spent.busy / sim.clock, 2) * 100, "% of the time.\n")
cat0("The average line size was ", round(total.cumulative.line.size / sim.clock, 2), " people.\n")
