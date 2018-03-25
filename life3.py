
# Conway's Game of Life version 3: third ("mega") state
# Stephen Davies -- CPSC 420

import numpy as np
import matplotlib.pyplot as plt

# Defining arbitrary integers to represent the possible states of each cell.
EMPTY = 0
POP = 1
MEGA = 2

# Return the number of populated neighbors (populated and/or "mega") (0-8) of
# cell x,y on this grid.
def num_neighbors(grid,x,y):
    neighbors = 0
    neighbor_states = [POP,MEGA]
    if x < WIDTH-1 and grid[x+1,y] in neighbor_states:               # Right
        neighbors = neighbors + 1
    if x > 0 and grid[x-1,y] in neighbor_states:                     # Left
        neighbors = neighbors + 1
    if y < HEIGHT-1 and grid[x,y+1] in neighbor_states:              # Up
        neighbors = neighbors + 1
    if y > 0 and grid[x,y-1] in neighbor_states:                     # Down
        neighbors = neighbors + 1
    if x < WIDTH-1 and y < HEIGHT-1 and grid[x+1,y+1] in neighbor_states:
        neighbors = neighbors + 1
    if x > 0 and y > 0 and grid[x-1,y-1] in neighbor_states:         # Lower-left
        neighbors = neighbors + 1
    if x < WIDTH-1 and y > 0 and grid[x+1,y-1] in neighbor_states:   # Lower-right
        neighbors = neighbors + 1
    if x > 0 and y < HEIGHT-1 and grid[x-1,y+1] in neighbor_states:  # Upper-left
        neighbors = neighbors + 1
    return neighbors


# Return the value that cell x,y should have in the next generation, based on
# its state and neighbors in the generation whose grid is passed.
def value_next_gen(grid,x,y):
    nn =  num_neighbors(grid,x,y)
    if nn in GO_MEGA and grid[x,y] != MEGA:
        # I am not MEGA right now, but am becoming so. Start my timer.
        timer[x,y] = MEGA_TIME
        return MEGA
    elif grid[x,y] == POP:
        if nn in SURVIVE:
            return POP
        else:
            return EMPTY
    elif grid[x,y] == EMPTY:
        if nn in BIRTH:
            return POP
        else:
            return EMPTY
    else:  # MEGA
        if timer[x,y] != 0:
            # I am MEGA right now, and am remaining so. Decrement my timer.
            timer[x,y] -= 1
            return MEGA
        else:
            # I am MEGA right now, but that's "so last generation."
            return EMPTY


# Given a 2d array of cells, return a list with the x-coordinates (in a list)
# and the y-coordinates (in another list) of the cells that have value "val".
def points_for_grid(grid, val=POP):
    xcoords = []
    ycoords = []
    for i in range(0,WIDTH):
        for j in range(0,HEIGHT):
            if grid[i,j] == val:
                xcoords.append(j)
                ycoords.append(i)
    return [xcoords,ycoords]
                

# Simulation parameters.
WIDTH = 20
HEIGHT = 20
NUM_GEN = 100
MEGA_TIME = 20   # The number of generations a "mega" cell will stay mega.
PROB_POP = .2    # The fraction of cells that will start off populated.

# The number of neighbors required for a currently populated cell to stay
# populated.
SURVIVE = [2,3]

# The number of neighbors required for a currently empty cell to become
# populated.
BIRTH = [3]

# The number of neighbors required for a cell to become "mega."
GO_MEGA = [5]


# This 3d array will use the third coordinate as a generation number, and thus
# represent the entire lifetime of the simulated model.
cube = np.empty((WIDTH, HEIGHT, NUM_GEN))

# Create a random starting configuration with about PROB_POP of the cells
# being initially populated, and the others empty.
config = np.random.choice([EMPTY,POP,MEGA],
    p=[1-PROB_POP,PROB_POP,0],size=WIDTH*HEIGHT)
config.shape = (WIDTH,HEIGHT)
cube[:,:,0] = config

# Create a grid to hold the "timer" for every cell in the mega state. The
# value of x,y in this grid will be the number of generations a mega cell has
# before it expires and goes back to empty. The other cells are meaningless.
timer = np.zeros(WIDTH * HEIGHT)
timer.shape = (WIDTH, HEIGHT)


# Run the simulation.
for gen in range(1,NUM_GEN):
    for x in range(WIDTH):
        for y in range(HEIGHT):
            cube[x,y,gen] = value_next_gen(cube[:,:,gen-1],x,y)


# Animate the results.
for gen in range(0,5):
    plt.clf()
    plt.xlim(-1,WIDTH)
    plt.ylim(-1,HEIGHT)
    xcoords, ycoords = points_for_grid(cube[:,:,gen],POP)
    plt.scatter(xcoords,ycoords,marker="o",color="blue")
    xcoords, ycoords = points_for_grid(cube[:,:,gen],MEGA)
    plt.scatter(xcoords,ycoords,marker="P",color="red")
    plt.title("Generation #" + str(gen))
    plt.pause(.05)
