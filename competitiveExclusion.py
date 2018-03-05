
# Meadows ch.5 "Competitive Exclusion" system trap ("The Matthew Effect")
# CPSC 420 -- spring 2016

import numpy as np
import matplotlib.pyplot as plt

# Set up t. (delta_t and t vector).
delta_t = 1/7     # weeks
t = np.arange(0,2000,delta_t)

# Simulation parameters (inputs).
earnings_rate_company1 = .46    # ($earned/$capital)/week
earnings_rate_company2 = .45    # ($earned/$capital)/week
investment_frac_company1 = .3   # ($reinvested/$earned)/week
investment_frac_company2 = .3   # ($reinvested/$earned)/week
depreciation_rate = .1          # ($depreciated/$capital)/week
economy_cc = 10000              # $/week (in earnings) saturation point

# Stocks. (Create a vector and an initial condition for each.)
company1_capital = np.empty(len(t))    # $
company1_capital[0] = 400
company2_capital = np.empty(len(t))    # $
company2_capital[0] = 400

profits_company1 = np.empty(len(t))    # $
profits_company1[0] = 0
profits_company2 = np.empty(len(t))    # $
profits_company2[0] = 0

earnings_company1 = 0
earnings_company2 = 0

for i in range(1,len(t)):

    logistic_factor = 1 - (earnings_company1 + earnings_company2) / economy_cc

    # Flows.
    earnings_company1 = (company1_capital[i-1] * earnings_rate_company1 *
                                            logistic_factor)
    investment_company1 = earnings_company1 * investment_frac_company1
    profits_company1[i] = earnings_company1 * (1 - investment_frac_company1)

    earnings_company2 = (company2_capital[i-1] * earnings_rate_company2 *
                                            logistic_factor)
    investment_company2 = earnings_company2 * investment_frac_company2
    profits_company2[i] = earnings_company2 * (1 - investment_frac_company2)

    depreciation_company1 = company1_capital[i-1] * depreciation_rate
    depreciation_company2 = company2_capital[i-1] * depreciation_rate

    # Primes.
    company1_capital_prime = investment_company1 - depreciation_company1
    company2_capital_prime = investment_company2 - depreciation_company2

    # Stocks.
    company1_capital[i] = (company1_capital[i-1] + 
        company1_capital_prime * delta_t)
    company2_capital[i] = (company2_capital[i-1] + 
        company2_capital_prime * delta_t)

# Plot and analyze.
plt.clf()
plt.plot(t, company1_capital, color="blue", linestyle="-", linewidth=2,
    label="Company 1 capital")
plt.plot(t, company2_capital, color="red", linestyle="--", linewidth=2,
    label="Company 2 capital")
plt.plot(t, profits_company1, color="blue", linestyle=":", linewidth=2,
    label="Company 1 profits")
plt.plot(t, profits_company2, color="red", linestyle=":", linewidth=1,
    label="Company 2 profits")
plt.title("Competitive exclusion")
plt.xlabel("weeks")
plt.ylabel("$")
plt.legend()
plt.show()
