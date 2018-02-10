
# Aliens vs. vampires version 2: logistic growth
# Stephen Davies -- CPSC 420

import numpy as np
import matplotlib.pyplot as plt

delta_t = .1                                    # years
time_values = np.arange(1940, 2310, delta_t)    # years

abduction_factor = 720000   # (abductees/year)/year
bite_factor = .1            # (vampires/year)/vampire
baby_factor = .01           # (people/year)/person

# Create (empty) arrays for the stocks.
A = np.zeros(len(time_values))
V = np.zeros(len(time_values))
H = np.zeros(len(time_values))

# Initial conditions: start off with 7 billion people, no abductees, and 
# one lonely vampire.
A[0] = 0
V[0] = 1
H[0] = 7e9


for i in range(1,len(time_values)):

    # Logistic growth: The rate of vampire bites will be gradually reduced as
    # the number of victims in the population shrinks.
    logistic_factor = H[i-1]/(H[i-1] + V[i-1])

    # Calculate the rate of vampirization.
    bite_rate = V[i-1] * bite_factor * logistic_factor

    # Calculate rate of alien abduction (and don't let it surpass the number
    # of actual eligible victims!) This is a hard cutoff, rather than the
    # gentle logistic curve.
    abduction_rate = abduction_factor * (time_values[i-1] - 1940)
    if abduction_rate > H[i-1] / delta_t:
        abduction_rate = H[i-1] / delta_t

    # Calculate the rate of human population growth. (We're assuming no
    # natural deaths here, so our baby_factor is actually lower than it would
    # be in real life.)
    baby_rate = H[i-1] * baby_factor


    # Calculate derivatives.
    A_prime = abduction_rate
    V_prime = bite_rate
    H_prime = baby_rate - bite_rate - abduction_rate

    # Calculate stocks.
    A[i] = A[i-1] + A_prime * delta_t
    V[i] = V[i-1] + V_prime * delta_t
    H[i] = H[i-1] + H_prime * delta_t


plt.plot(time_values,A, color="green", label="alien abductees")
plt.plot(time_values,V, color="red", label="vampires")
plt.plot(time_values,H, color="black", label="peeps")
plt.xlabel("year")
plt.legend()
plt.show()
