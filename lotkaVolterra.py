
import matplotlib.pyplot as plt
import numpy as np

delta_t = 1/30/24               # months (1 hour)
t = np.arange(0,12*3,delta_t)   # months (3 years)

bat_birth_factor = 2     # (bats/month)/bat
bat_death_factor = 3     # (bats/month)/bat
mouse_birth_factor = 3   # (mice/month)/mouse
mouse_death_factor = 2   # (mice/month)/mouse
nutrition_factor = .2    # bats/kill

kill_ratio = .2          # kills/encounter
enc_frequency = .2       # (encounters/month)/bat/mouse

B = np.empty(len(t))
M = np.empty(len(t))
B[0] = 15
M[0] = 100

for i in range(1,len(t)):
    
    # Flows.
    mouse_birth_rate = mouse_birth_factor * M[i-1]      # mouse/month
    bat_birth_rate = bat_birth_factor * B[i-1]          # bat/month
    mouse_death_nc_rate = mouse_death_factor * M[i-1]   # mouse/month
    bat_death_nc_rate = bat_death_factor * B[i-1]       # bat/month
    encounter_rate = enc_frequency * B[i-1] * M[i-1]    # enc/month
    kill_rate = kill_ratio * encounter_rate             # kills/month (mice/mo)
    mouse_death_rate = mouse_death_nc_rate + kill_rate  # mice/month
    bat_death_rate = bat_death_nc_rate - nutrition_factor * kill_rate
        # bats/month

    # Primes.
    M_prime = mouse_birth_rate - mouse_death_rate       # mice/month
    B_prime = bat_birth_rate - bat_death_rate           # bats/month

    # Stocks.
    M[i] = M[i-1] + M_prime * delta_t
    B[i] = B[i-1] + B_prime * delta_t


plt.clf()
plt.plot(t,B,color="black",label="bats",linewidth=2)
plt.plot(t,M,color="red",label="mice",linestyle=":")
#plt.axvline(M.argmax()*delta_t,color="green",linestyle="--")
#plt.axvline(B.argmax()*delta_t,color="purple",linestyle="--")
plt.ylim(0,M.max()+10)
plt.xlabel("months")
plt.legend()
plt.show()
