
# Wolfram's 1-d Cellular Automata
# Stephen Davies -- CPSC 420

import numpy as np
import matplotlib.pyplot as plt

# Simulation parameters.
WIDTH = 280
NUM_GEN = 250

# The initial config is the first row.
config = np.random.choice([0,1],p=[.5,.5],size=WIDTH)

# (Uncomment these lines to start the model with a single populated cell.)
#config = np.zeros(WIDTH)
#config[int(WIDTH/2)] = 1

# The "grid" is the entire history of the model: each row, starting with 0, is
# one generation.
grid = np.zeros(WIDTH * NUM_GEN)
grid.shape = (WIDTH, NUM_GEN)
grid[:,0] = config

# Prompt the user for a rule number. This (base-10) number, in the range
# 0-255, will be converted to binary to form the "DNA" of the CA.
rule = int(input("What rule #, bub? "))
dna = [ int(x) for x in list(bin(rule)[2:]) ]
extra_zeros = [0]*(8-len(dna))
dna = extra_zeros + dna
dna.reverse()

# Given a 2d array, return a list with the x-coordinates (in a list) and the
# y-coordinates (in another list) of the cells with value 1.
def points_for_grid(grid):
    xc = []
    yc = []
    for x in range(WIDTH):
        for y in range(NUM_GEN):
            if grid[x,y] == 1:
                xc.append(x)
                yc.append(NUM_GEN-y)
    return xc,yc    


# Run the simulation.
for gen in range(1,NUM_GEN):
    for x in range(WIDTH):
        if x == 0:
            my_left = 0
        else:
            my_left = grid[(x-1),gen-1]
        if x == WIDTH-1:
            my_right = 0
        else:
            my_right = grid[(x+1),gen-1]
        three = [my_left, grid[x,gen-1], my_right]
        state = three[0] * 4 + three[1] * 2 + three[2] * 1 
        grid[x,gen] = dna[int(state)]


# Plot the results.
xc,yc = points_for_grid(grid)
plt.clf()
plt.scatter(xc,yc,marker='.')
plt.xlim(0,WIDTH)
plt.ylim(0,NUM_GEN)
plt.title("Rule #" + str(rule) + " (" + 
    ''.join(reversed([str(x) for x in dna])) +")")
plt.show()

