
# Aliens vs. vampires version 1: polynomial vs. exponential growth
# Stephen Davies -- CPSC 420

import numpy as np
import matplotlib.pyplot as plt

delta_t = .1                                    # years
time_values = np.arange(1940, 2110, delta_t)    # years

abduction_factor = 300   # (abductees/year)/year
bite_factor = .1           # (vampires/year)/vampire

# Create (empty) arrays for the stocks.
A = np.zeros(len(time_values))
V = np.zeros(len(time_values))

# Initial conditions: start off with no abductees, and one lonely vampire.
A[0] = 0
V[0] = 1


for i in range(1,len(time_values)):

    A_prime = abduction_factor * i * delta_t
    V_prime = bite_factor * V[i-1]

    A[i] = A[i-1] + A_prime * delta_t
    V[i] = V[i-1] + V_prime * delta_t


plt.clf()
plt.plot(time_values,A, color="green", label="alien abductees")
plt.plot(time_values,V, color="red", label="vampires")
plt.xlabel("year")
plt.legend()
plt.show()
