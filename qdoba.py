
# Queueing model (first Discrete-Event Simulation)
# Stephen Davies -- CPSC 420

import matplotlib.pyplot as plt
import numpy as np

# (Constants for the server's state.)
IDLE = 0
BUSY = 1

# Simulation state variables.
clock = 0
state = IDLE
num_in_line = 0

# Average rates of service and arrival, in burritos/min and customers/min.
SERVICE_RATE = 4        # per-min
INTERARRIVAL_RATE = 3.5   # per-min

# Event list. Start off with one scheduled arrival, and no scheduled service 
# events.
next_service = np.inf
next_arrival = np.random.exponential(1/INTERARRIVAL_RATE,1)[0]

# We'll keep the store open for 10 hours.
QUITTIN_TIME = 10*60

# Statistical counter to track how long the line ever gets.
max_line_size = 0
total_line_area_or_weight_before_division = 0
total_utilization = 0

# Coordinates of points for line-size plot. Each change in line size will
# result in *two* points added to these lists, one for each 90-degree "corner"
# at that clock time.
xs = [0]
ys = [0]


# Main simulation loop. Continue looping as long as there are any events still
# scheduled.
while next_arrival < np.inf or next_service < np.inf:

    # Advance the simulation clock to the time of the next scheduled event.
    prev_clock = clock
    clock = min(next_arrival, next_service)

    if next_arrival < next_service:
        # It's an arrival event!
        print("{:.2f}: Somebody just walked in!".format(clock))
        if state == IDLE:
            print("   Server gets up   *groooooan*")
            next_service = (clock +
                np.random.exponential(1/SERVICE_RATE,1)[0])
            state = BUSY
        else:
            xs.append(clock)
            ys.append(num_in_line)
            total_line_area_or_weight_before_division += \
                num_in_line * (clock - prev_clock)
            num_in_line += 1
            xs.append(clock)
            ys.append(num_in_line)
            if num_in_line > max_line_size:
                max_line_size = num_in_line
            print(" ...and has to wait in line. (line now " + 
                str(num_in_line) + ")")

        # Schedule the next arrival after this one.
        next_arrival = (clock +
            np.random.exponential(1/INTERARRIVAL_RATE,1)[0])
        # The doors close at QUITTIN_TIME, and although we will continue to
        # serve the customers in line at that time, we won't let anyone else
        # join the line. (So don't schedule any arrivals later than that.)
        if next_arrival > QUITTIN_TIME:
            next_arrival = np.inf

    else:
        # It's a service event!
        print("{:.2f}: A burrito just got made!".format(clock))
        if num_in_line > 0:
            state = BUSY    # (not strictly necessary; defensive programming)
            xs.append(clock)
            ys.append(num_in_line)
            total_line_area_or_weight_before_division += \
                num_in_line * (clock - prev_clock)
            num_in_line -=1
            xs.append(clock)
            ys.append(num_in_line)
            print(" next chump gets served. (line now " + 
                str(num_in_line) + ")")
            next_service = (clock +
                np.random.exponential(1/SERVICE_RATE,1)[0])
        else:
            state = IDLE
            next_service = np.inf
            print("   Server gets to sit down!  *aaahhhhh*")



avg_line_size = total_line_area_or_weight_before_division / clock

plt.clf()
plt.title(("The line got up to {}\nExpected line size: {:.2f}").format(
    max_line_size,avg_line_size))
plt.plot(xs,ys)
plt.xlabel("minutes since opening")
plt.ylabel("# customers in line")
plt.annotate("Quittin' time",(QUITTIN_TIME-20,max_line_size*.9),color="purple",
    rotation=90)
plt.axhline(avg_line_size,color="red")
plt.axvline(QUITTIN_TIME,color="purple",linestyle="dotted")
plt.show()
