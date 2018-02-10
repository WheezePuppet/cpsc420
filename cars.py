
# Meadows ch.2 Car Dealership: delays
# Stephen Davies -- CPSC 420

import matplotlib.pyplot as plt
import numpy as np

delta_t = 1                         # day
t = np.arange(0,365*3,delta_t)      # days

lot_size = 100          # cars
stocking_factor = 10    # cars-on-lot/(cars/day)

perception_delay = 3    # days  (Meadows' delay #1)
replenish_delay = 2     # days  (Meadows' delay #2)
delivery_delay = 9      # days  (Meadows' delay #3)

cust_demand = .2        # (cars/day)/car

replenish_factor = 1/(replenish_delay+1)  # (cars/day)/car-diff


# Inventory of cars on lot each day.
I = np.empty(len(t))

# Orderes placed for cars each day.
O = np.empty(len(t))

# Start with 10 cars on the lot, and nothing on backorder.
I[0] = 10
O[0] = 0


for i in range(1,len(t)):

    # Model sales as a fraction of inventory.
    sales_rate = cust_demand * I[i-1]

    # The dealer will perceive the true "cars sold per day" as an average of
    # the past few days' sales, rather than only the instantaneously most
    # recent day.
    perceived_sales_rate = sales_rate if i <= perception_delay else \
        I[(i-perception_delay-1):i].mean() * cust_demand

    # The dealer desires there to be some multiple of the (perceived) sales
    # rate in stock (but of course, no higher than the lot can hold.)
    desired_inventory = min(lot_size, perceived_sales_rate * stocking_factor)

    # Discrepancy: how short we are of the cars we desire.
    discrepancy = desired_inventory - I[i-1]

    # Order more cars if we have fewer than we'd like. Do it over some number
    # of days rather than all at once.
    O[i] = replenish_factor * discrepancy if discrepancy > 0 else 0

    # The deliveries arriving on day i are those cars ordered delivery_delay
    # days ago.
    delivery_rate = O[int(i-delivery_delay/delta_t)] \
        if i > delivery_delay/delta_t else 0 

    # Calculate primes and stocks.
    I_prime = delivery_rate - sales_rate
    I[i] = I[i-1] + I_prime * delta_t

plt.plot(t,I,color="red",label="cars on lot")
plt.plot(t,O,color="black",label="cars ordered")
plt.ylim(0,100)
plt.legend()
plt.show()
