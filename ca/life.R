
# Conway's Game of Life -- version 1.0
# CPSC 420 -- spring 2016

# Possible states of CA cells.
EMPTY <- 0
POPULATED <- 1

# Dimensions of CA.
height <- 30
width <- 30
num.gen <- 100

# Our system's state.
config <- matrix(
    c(
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ), nrow=30, byrow=TRUE)
da.cube <- array(EMPTY,dim=c(height,width,num.gen))
da.cube[,,1] <- config


# Return the number of neighbors that a particular cell has in a specified
# generation. If the cell is on the grid border, do not count its phantom
# cells over the boundary as "neighbors."
num.neighbors <- function(row,col,gen) {
    n <- 0
    # above
    if (row > 1  &&  da.cube[row-1,col,gen] == POPULATED) {  
        n <- n + 1
    }
    # above left
    if (row > 1 && col > 1  && da.cube[row-1,col-1,gen] == POPULATED) {
        n <- n + 1
    }
    # above right
    if (row > 1 && col < width  && da.cube[row-1,col+1,gen] == POPULATED) {
        n <- n + 1
    }
    # left
    if (col > 1  && da.cube[row,col-1,gen] == POPULATED) {
        n <- n + 1
    }
    # right
    if (col < width  && da.cube[row,col+1,gen] == POPULATED) {
        n <- n + 1
    }
    # below 
    if (row < height && da.cube[row+1,col,gen] == POPULATED) {
        n <- n + 1
    }
    # below left
    if (col > 1  && row < height && da.cube[row+1,col-1,gen] == POPULATED) {
        n <- n + 1
    }
    # below right
    if (col < width  && row < height && da.cube[row+1,col+1,gen] == POPULATED) {
        n <- n + 1
    }
    n
}


# Return true only if the cell whose row and column are specified (which
# was presumably populated in the previous generation) should stay
# populated in the current generation.
stay.alive <- function(row,col,prevGen) {
    nn <- num.neighbors(row,col,prevGen)
    if (nn == 2 || nn == 3) {
        return(T)
    } else {
        return(F)
    }
}


# Return true only if the cell whose row and column are specified (which
# was presumably empty in the previous generation) should become populated 
# in the current generation.
spawn <- function(row,col,prevGen) {
    nn <- num.neighbors(row,col,prevGen)
    if (nn == 3) {
        return(T)
    } else {
        return(F)
    }
}


# Return a list of x-coordinates and corresponding y-coordinates for the
# points whose cells in the specific generation are in a certain state
# (default POPULATED).
points.for.grid <- function(gen, value=POPULATED) {
    xcoords <- vector()
    ycoords <- vector()
    for (row in 1:height) {
        for (col in 1:width) {
            if (da.cube[row,col,gen] == value) {
                xcoords <- c(xcoords,col)
                ycoords <- c(ycoords,height-row+1)
            }
        }
    }
    return(list(xcoords,ycoords))
}


# Plot the points for the generation number passed.
plot.gen <- function(gen) {
    Sys.sleep(.4)
    ppg <- points.for.grid(gen)
    plot(ppg[[1]],ppg[[2]],xlim=c(1,width),ylim=c(1,height),pch=19,
        xlab="",ylab="", main="Conway's Game of Life")
}


# Simulate this bad boy.
for (gen in 2:num.gen) {

    # Plot the populated points.
    plot.gen(gen-1)

    for (row in 1:height) {

        for (col in 1:width) {

            # Get the previous value for this row and column.
            prevVal <- da.cube[row,col,gen-1]

            if (prevVal == EMPTY) {
                if (spawn(row,col,gen-1)) {
                    da.cube[row,col,gen] <- POPULATED
                }
            } else if (stay.alive(row,col,gen-1)) {
                    da.cube[row,col,gen] <- POPULATED
            }
        }
    }
}
