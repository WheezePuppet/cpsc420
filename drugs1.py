
# Drugs version 1: exponential decay
# Stephen Davies -- CPSC 420

import matplotlib.pyplot as plt
import numpy as np
import math

simulation_hrs = 24                                     # hours
delta_t = 5/60                                          # hours
time_values = np.arange(0, simulation_hrs, delta_t)     # hours
dosage_freq = 2                                         # hours
dosage = 2 * 325 * 1000                                 # ug

half_life = 3.2                                         # hours
plasma_volume = 3000                                    # ml
elimination_constant = math.log(2)/half_life            # 1/hour

# Create an (empty) array for the stock.
D = np.zeros(len(time_values))                          # ug

# Initial conditions: pop two aspirin at the start of the simulation.
D[0] = dosage                                           # ug


for i in range(1, len(time_values)):

    # Compute the values for the flows.
    elimination_rate = elimination_constant * D[i-1]    # ug/hr

    # Add up all the values for the "primes."
    D_prime = -elimination_rate                         

    # Calculate the next value of the stocks, based on the primes.
    D[i] = D[i-1] + D_prime * delta_t

    # If it's time to pop another pill, do so, by just adding to the stock.
    if i in np.arange(0,len(time_values),int(dosage_freq/delta_t)):
        D[i] += dosage
        

# Compute the value for the derived stock.
plasma_concentration = D / plasma_volume

# MEC: Minimum Effective Concentration (has to be this high to do any good)
mec = 150 # ug/ml

# MTC: Maximum Therapeutic Concentration (don't exceed!)
mtc = 350 # ug/ml

plt.plot(time_values, plasma_concentration)
plt.axhline(mec, color="blue")
plt.axhline(mtc, color="red")
plt.ylim(0,max(plasma_concentration.max(), 400))

plt.show()
