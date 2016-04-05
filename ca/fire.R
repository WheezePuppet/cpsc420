
# Forest fire simulation -- version 1.0
# (Shiflet section 10.3)
# CPSC 420 -- spring 2016

EMPTY <- 0
TREE <- 1
BURNING <- 2

points.for.grid <- function(grid,val) {
    xcoords <- vector()
    ycoords <- vector()
    for (row in 1:nrow(grid)) {
        for (col in 1:ncol(grid)) {
            if (grid[row,col] == val) {
                xcoords[length(xcoords)+1] <- col
                ycoords[length(ycoords)+1] <- nrow(grid) - row
            }
        }
    }
    return(list(xcoords,ycoords))
}

# Decide what to do with a particular site on the current time step, given its
# current state (site), the state of its four Von Neumann neighbors, and the
# simulation probabilities.
spread <- function(site, N, E, S, W, chance.immune, chance.lightning) {
    neighbors <- c(N,E,S,W)
    if (site == TREE) {
        if (any(neighbors==BURNING) && runif(1) > chance.immune) {
            return(BURNING)
        }
        return(ifelse(runif(1) < chance.lightning, BURNING, TREE))
    }
    return(EMPTY)
}

# Extend the lattice by duplicating the edge rows/columns.
extendLat1 <- function(grid) {
    grid <- rbind(grid[,1],grid,grid[,nrow(grid)])
    grid <- cbind(grid[,1],grid,grid[,ncol(grid)])
    return(grid)
}

# n - Number of rows (and columns) in square grid.
# prob.tree - Fraction of original grid squares that have trees.
# prob.burning - Fraction of original trees that are initially burning.
# chance.lightning - The probability of each tree spontaneously catching fire
#   every time step.
# chance.immune - The probability, each time step, that a non-burning tree
#   with at least one non-burning neighbor will nevertheless not catch on fire
#   that step.
# t - The number of time steps to simulate.
fire <- function(n, prob.tree=.6, prob.burning=.0005,
    chance.lightning=.0001, chance.immune=.05, t=500) {

    # The lattice is a 3-d cube, where dimensions 1 and 2 are the rows and
    # columns of the forest, and dimension 3 is the time step.
    lattice <- array(dim=c(n,n,t))

    lattice[,,1] <- ifelse(runif(n^2,min=0,max=1)<prob.tree,TREE,EMPTY)
    lattice[,,1] <- ifelse(lattice[,,1] == TREE & 
        runif(n^2)<prob.burning,BURNING,lattice[,,1])

    for (step in 2:t) {
        trees <- points.for.grid(lattice[,,step-1],TREE)
        burnings <- points.for.grid(lattice[,,step-1],BURNING)
        plot(trees[[1]],trees[[2]],pch=17,col="green",
            xlim=c(0,n+1),ylim=c(0,n+1))
        points(burnings[[1]],burnings[[2]],col="red",pch=23,bg="orange")
        big <- extendLat1(lattice[,,step-1])
        for (row in 2:(n+1)) {
            for (col in 2:(n+1)) {
                lattice[row-1,col-1,step] <- 
                    spread(
                        big[row,col],
                        big[row-1,col],
                        big[row,col+1],
                        big[row+1,col],
                        big[row,col-1],
                        chance.immune, chance.lightning)
            }
        }
    }

    return(lattice)
}

# Fire!
lattice <- fire(50)
