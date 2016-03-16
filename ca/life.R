
# Conway's Game of Life -- version 1.0
# CPSC 420 -- spring 2016

# Possible states of CA cells.
EMPTY <- 0
POP <- 1
UBER <- 2

NYC.END.ROW <- 15
NYC.START.COL <- 15

# Dimensions of CA.
height <- 30
width <- 30
num.gen <- 100



# A random starting configuration.
config <- matrix(rbinom(height*width,size=1,prob=.09),nrow=height)
config[1:NYC.END.ROW,NYC.START.COL:width] <- EMPTY

# Our system's state.
da.loaf <- array(EMPTY, dim=c(height,width,num.gen))
da.loaf[,,1] <- config


# Return the number of populated neighbors of (row,col) in the current
# generation. (If (row,col) is a border cell of the grid, assume its
# non-existent across-the-border neighbors are *not* populated.)
num.neighbros <- function(da.loaf,row,col,gen) {
    bros <- 0
    neighbro.states <- c(POP,UBER)
    if (row > 1 && col > 1 && da.loaf[row-1,col-1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (row > 1 && da.loaf[row-1,col,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (row > 1 && col < width && da.loaf[row-1,col+1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (col > 1 && da.loaf[row,col-1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (col < width && da.loaf[row,col+1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (row < height && col > 1 && da.loaf[row+1,col-1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (row < height && da.loaf[row+1,col,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    if (row < height && col < width && da.loaf[row+1,col+1,gen] %in% neighbro.states) {
        bros <- bros + 1
    }
    return(bros)
}

in.nyc <- function(row,col) {
    if (row <= NYC.END.ROW  &&  col >= NYC.START.COL) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}

# Return true if the cell in (row,col) of the previous generation was
# populated.
was.just.alive <- function(da.loaf,row,col,current.gen) {
    return (da.loaf[row,col,current.gen-1] == POP)
}

# Return true if the (presumably populated) cell in (row,col) of the previous
# generation should stay populated in the current generation.
should.stay.alive <- function(da.loaf,row,col,current.gen) {
    if (in.nyc(row,col)) {
        return (num.neighbros(da.loaf,row,col,current.gen-1) %in% c(4,5,6,7))
    } else {
        return (num.neighbros(da.loaf,row,col,current.gen-1) %in% c(2,3))
    }
}

# Return true if the (presumably empty) cell in (row,col) of the previous
# generation should become populated in the current generation.
should.spawn <- function(da.loaf,row,col,current.gen) {
    if (in.nyc(row,col)) {
        return (num.neighbros(da.loaf,row,col,current.gen-1) %in% c(3,4,5,6))
    } else {
        return (num.neighbros(da.loaf,row,col,current.gen-1) == 3)
    }
}

should.be.uber <- function(da.loaf,row,col,current.gen) {
    return (da.loaf[row,col,current.gen-1] == UBER  ||
        num.neighbros(da.loaf,row,col,current.gen-1) %in% c(5))
}

# Plot the grid for the generation specified.
plot.gen <- function(da.loaf,gen) {
    xcoords <- vector()
    ycoords <- vector()
    xubercoords <- vector()
    yubercoords <- vector()
    for (row in 1:height) {
        for (col in 1:width) {
            if (da.loaf[row,col,gen] == POP) {
                xcoords <- c(xcoords,col)
                ycoords <- c(ycoords,height-row+1)
            }
            if (da.loaf[row,col,gen] == UBER) {
                xubercoords <- c(xubercoords,col)
                yubercoords <- c(yubercoords,height-row+1)
            }
        }
    }
    plot(xcoords,ycoords,pch=20,col="blue",ylim=c(0,height),xlim=c(0,width))
    points(xubercoords,yubercoords,pch=20,col="red")
}




# Plot the starting configuration.
plot.gen(da.loaf,1)


# Main loop. For each generation, compute and plot its grid.
for (gen in 2:num.gen) {

    for (row in 1:height) {
        
        for (col in 1:width) {

            if (should.be.uber(da.loaf,row,col,gen)) {
                da.loaf[row,col,gen] <- UBER 
            } else if ((was.just.alive(da.loaf,row,col,gen) && 
                should.stay.alive(da.loaf,row,col,gen))  ||
                (!was.just.alive(da.loaf,row,col,gen) && 
                should.spawn(da.loaf,row,col,gen))) {

                da.loaf[row,col,gen] <- POP                
            }
        }
    }
    plot.gen(da.loaf,gen)
}


# Plot post-mortem analysis.
#total.pops <- apply(da.loaf,3,sum)
#plot(1:num.gen,total.pops,type="l", main="Total population over time",
#    ylim=c(0,max(total.pops)))

