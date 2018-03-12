
import matplotlib.pyplot as plt
import numpy as np

delta_t = 1/60  # hour
t = np.arange(8,7+24,delta_t)

to_Q = 1.5  # (cars/hour)/car
to_W = 2    # (cars/hour)/car
to_M = .1   # (cars/hour)/car
to_D = .5   # (cars/hour)/car

F = np.empty(len(t))
Q = np.empty(len(t))
W = np.empty(len(t))
M = np.empty(len(t))
D = np.empty(len(t))
F[0] = 400
Q[0] = 0
W[0] = 0
M[0] = 0
D[0] = 0

for i in range(1,len(t)):

    # Flows:
    F_to_Q = to_Q * F[i-1]
    Q_to_W = to_W * Q[i-1]
    W_to_M = to_M * W[i-1]
    M_to_D = to_D * M[i-1]

    # Primes:
    F_prime = -F_to_Q
    Q_prime = F_to_Q - Q_to_W
    W_prime = Q_to_W - W_to_M
    M_prime = W_to_M - M_to_D
    D_prime = M_to_D

    # Stocks:
    F[i] = F[i-1] + F_prime * delta_t
    Q[i] = Q[i-1] + Q_prime * delta_t
    W[i] = W[i-1] + W_prime * delta_t
    M[i] = M[i-1] + M_prime * delta_t
    D[i] = D[i-1] + D_prime * delta_t



plt.clf()
plt.plot(t, F, color="red", label="Fred")
plt.plot(t, Q, color="purple", label="Quantico")
plt.plot(t, W, color="blue", label="Woodbridge")
plt.plot(t, M, color="green", label="Manassas")
plt.plot(t, D, color="black", label="DC")
plt.plot(t, F+Q+W+M+D, color="orange", linestyle="--", label="All")
plt.legend()
plt.xlabel("hours past midnight")
plt.ylabel("# of vehicles")
plt.show()
