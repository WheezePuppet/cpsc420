
# Meadows ch.2 Two stock model with non-renewable resource
# Stephen Davies -- CPSC 420

import matplotlib.pyplot as plt
import numpy as np

growth_goal = .03      # ($/$)/year
capital_lifetime = 40  # years
operating_cost = 6     # ($/year)/$

yield_per_cap = 2/50000     # ((gallons/year)/$)/gallon
price = 20                  # $/gallon

delta_t = .1                    # years
t = np.arange(0,500,delta_t)    # years

C = np.empty(len(t))
R = np.empty(len(t))
extraction = np.empty(len(t))
C[0] = 100                      # $
R[0] = 50000                    # gallons
extraction[0] = 0               # gallons/year

for i in range(1,len(t)):

    # Flows.
    extraction[i] = C[i-1] * yield_per_cap * R[i-1]    # gallons/year
    income = extraction[i] * price                     # $/year
    cost = C[i-1] * operating_cost                     # $/year
    profit = income - cost                             # $/year
    investment = min(C[i-1] * growth_goal, profit/50)  # $/year     
    depreciation = C[i-1] / capital_lifetime           # $/year

    # Primes.
    C_prime = investment - depreciation    # $/year
    R_prime = -extraction[i]                  # gallons/year

    # Stocks.
    C[i] = C[i-1] + C_prime * delta_t
    R[i] = R[i-1] + R_prime * delta_t


plt.plot(t,C*20,color="black",label="capital")
plt.plot(t,R,color="brown",label="resource")
plt.plot(t,extraction*100,color="orange",label="extraction")
plt.legend()
plt.show()
