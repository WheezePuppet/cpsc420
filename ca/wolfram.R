
# Wolfram's 1-d cellular automata -- version 1.0
# CPSC 420 -- spring 2016

EMPTY <- 0
POP <- 1

num.gen <- 400
width <- 400

# Random initial configuration.
config <- rbinom(width,size=1,prob=.5)

# To make Thomas happy.
config[1] <- EMPTY
config[width] <- EMPTY

# Our system's entire state (one row for each generation).
grid <- matrix(rep(EMPTY,num.gen*width),nrow=num.gen)
grid[1,] <- config


# Given a rule number (integer), return an 8-bit vector of 1's and 0's
# representing the binary representation of the number. (Element [1] of the
# return value is the least-significant bit, and element [8] is the most
# significant.)
dna.for.rule.num <- function(num) {
    dna <- vector()
    for (i in 1:8) {
        dna[i] <- num %% 2
        num <- floor(num /2)
    }
    return(dna)
}

rule.num <- as.numeric(readline("what rule #?"))
dna <- dna.for.rule.num(rule.num)


# Plot the entire grid (all generations).
plot.gen <- function(grid,gen) {
    xcoords <- vector()
    ycoords <- vector()
    for (cell in 1:width) {
        if (grid[gen,cell] == POP) {
            xcoords <- c(xcoords,cell)
            ycoords <- c(ycoords,num.gen-gen+1)
        }
    }
    points(xcoords,ycoords,pch=20,cex=.2,col="blue")
}


# Initialize grid.
plot(c(1),c(1),ylim=c(1,num.gen), xlim=c(1,width), 
    main=paste0("Rule #",rule.num), xlab="", ylab="")

for (gen in 2:num.gen) {
    for (cell in 2:(width-1)) {

        # The "previous state" is the three cells in the generation before
        # this one which are to the immediate left of this cell, this cell
        # itself, and the immediate right of this cell.
        the.prev.state <- grid[gen-1,c(cell-1,cell,cell+1)]

        # Convert that previous state (like "110") to the equivalent integer
        # (like 6).
        the.prev.state.as.a.num <- sum(the.prev.state * c(4,2,1))

        # Look up that state in the DNA, and set this generation's cell value
        # to whatever the DNA dictates for that previous state.
        grid[gen,cell] <- dna[the.prev.state.as.a.num+1]
    }
    plot.gen(grid,gen)
}
