
# Queueing model (version 2 -- parameter sweep)
# Stephen Davies -- CPSC 420

import matplotlib.pyplot as plt
import numpy as np

# (Constants for the server's state.)
IDLE = 0
BUSY = 1

# Run one simulation, using the given SERVICE_RATE, and return a dictionary of
# statistical information about its performance. If the "V" parameter is set
# to True, print a running narrative of life in the store that day.
def runsim(SERVICE_RATE, V=False):

    # Simulation state variables.
    clock = 0
    state = IDLE
    num_in_line = 0

    NORM_INTERARRIVAL_RATE = 2   # per-min
    RUSH_INTERARRIVAL_RATE = 5   # per-min
    def get_arrival_rate(clock):
        if clock % 60 >= 50:
            return RUSH_INTERARRIVAL_RATE
        else:
            return NORM_INTERARRIVAL_RATE

    # Event list.
    next_service = np.inf
    next_arrival = np.random.exponential(1/get_arrival_rate(0),1)[0]

    # We'll keep the store open for 10 hours.
    QUITTIN_TIME = 10*60

    # Statistical counter to track how long the line ever gets.
    max_line_size = 0
    total_line_area_or_weight_before_division = 0
    total_utilization = 0
    burritos_made = 0


    # Main simulation loop. Continue looping as long as there are any events
    # still scheduled.
    while next_arrival < np.inf or next_service < np.inf:

        # Advance the simulation clock to the time of the next scheduled event.
        prev_clock = clock
        clock = min(next_arrival, next_service)

        if next_arrival < next_service:
            # It's an arrival event!
            if V: print("{:.2f}: Somebody just walked in!".format(clock))
            if state == IDLE:
                if V: print("   Server gets up   *groooooan*")
                next_service = (clock +
                    np.random.exponential(1/SERVICE_RATE,1)[0])
                state = BUSY
            else:
                total_utilization += (clock - prev_clock)
                total_line_area_or_weight_before_division += \
                    num_in_line * (clock - prev_clock)
                num_in_line += 1
                if num_in_line > max_line_size:
                    max_line_size = num_in_line
                if V: print(" ...and has to wait in line. (line now " + 
                    str(num_in_line) + ")")

            # Schedule the next arrival after this one.
            next_arrival = (clock +
                np.random.exponential(1/get_arrival_rate(clock),1)[0])
            # The doors close at QUITTIN_TIME, and although we will continue
            # to serve the customers in line at that time, we won't let anyone
            # else join the line. (So don't schedule any arrivals later than
            # that.)
            if next_arrival > QUITTIN_TIME:
                next_arrival = np.inf

        else:
            # It's a service event!
            burritos_made = burritos_made + 1
            total_utilization += (clock - prev_clock)
            if V: print("{:.2f}: A burrito just got made!".format(clock))
            if num_in_line > 0:
                total_line_area_or_weight_before_division += \
                    num_in_line * (clock - prev_clock)
                num_in_line -=1
                if V: print(" next chump gets served. (line now " + 
                    str(num_in_line) + ")")
                next_service = (clock +
                    np.random.exponential(1/SERVICE_RATE,1)[0])
            else:
                state = IDLE
                next_service = np.inf
                if V: print("   Server gets to sit down!  *aaahhhhh*")

    avg_line_size = total_line_area_or_weight_before_division / clock
    return { 'avg_line_size':avg_line_size,
        'max_line_size':max_line_size,
        'utilization':total_utilization/clock*100,
        'burritos_made':burritos_made }



# Run a parameter sweep with different service rates.
avg_line_sizes = []
max_line_sizes = []
utilizations = []
burritos_mades = []
service_rates = np.arange(.1,6,.1)
for service_rate in service_rates:
    results = runsim(service_rate)
    avg_line_sizes.append(results['avg_line_size'])
    max_line_sizes.append(results['max_line_size'])
    utilizations.append(results['utilization'])
    burritos_mades.append(results['burritos_made'])

# Display parameter sweep plots of the dependent variables.
plt.clf()
plt.subplot(221)
plt.plot(service_rates,avg_line_sizes)
plt.axvline(2,color="red")
plt.ylim(0,max(avg_line_sizes))
plt.xlabel("service rate (burritos/minute)")
plt.ylabel("expected line size")

plt.subplot(222)
plt.plot(service_rates,max_line_sizes)
plt.axvline(2,color="red")
plt.ylim(0,max(burritos_mades))
plt.xlabel("service rate (burritos/minute)")
plt.ylabel("max line size")

plt.subplot(223)
plt.plot(service_rates,utilizations)
plt.axvline(2,color="red")
plt.ylim(0,max(utilizations))
plt.xlabel("service rate (burritos/minute)")
plt.ylabel("utilization")

plt.subplot(224)
plt.plot(service_rates,burritos_mades)
plt.axvline(2,color="red")
plt.ylim(0,max(burritos_mades))
plt.xlabel("service rate (burritos/minute)")
plt.ylabel("total served")
plt.show()
