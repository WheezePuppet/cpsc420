
# Schelling's Segregation simulation -- version 1.0
# CPSC 420 -- spring 2016

probRed <- .42
probBlue <- .42

# What fraction of my neighbors (minimum) must look like me in order for me
# not to move?
thresh <- .4

RED <- 1
BLUE <- 2
EMPTY <- 3

width <- 60
height <- 60
numGen <- 40


numNeighborsOfColor <- function(city, row, col, color) {
    num <- 0
    if (row > 1 && col > 1 && city[row-1,col-1] == color) {
        num <- num + 1
    }
    if (col > 1 && city[row,col-1] == color) {
        num <- num + 1
    }
    if (row < height && col > 1 && city[row+1,col-1] == color) {
        num <- num + 1
    }
    if (row < height && city[row+1,col] == color) {
        num <- num + 1
    }
    if (row > 1 && city[row-1,col] == color) {
        num <- num + 1
    }
    if (row < height && col < width && city[row+1,col+1] == color) {
        num <- num + 1
    }
    if (col < height && city[row,col+1] == color) {
        num <- num + 1
    }
    if (row > 1 && col < height && city[row-1,col+1] == color) {
        num <- num + 1
    }
    return(num)
}

numRedNeighbors <- function(city, row, col) {
    return(numNeighborsOfColor(city, row, col, RED))
}

numBlueNeighbors <- function(city, row, col) {
    return(numNeighborsOfColor(city, row, col, BLUE))
}

computeRatio <- function(mycolor, city, row, col) {
    nred <- numRedNeighbors(city, row, col)
    nblue <- numBlueNeighbors(city, row, col)
    if (nred + nblue == 0) {
        return(1)
    }
    if (mycolor == RED) {
        ratio <- nred/(nred+nblue)
    } else {
        ratio <- nblue/(nred+nblue)
    }
    return(ratio)
}

belowThresh <- function(mycolor, city, row, col, thresh) {

    ratio <- computeRatio(mycolor, city, row, col)
    if (ratio < thresh) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}

pointsForGrid <- function(grid,val) {
    xcoords <- vector()
    ycoords <- vector()
    for (row in 1:nrow(grid)) {
        for (col in 1:ncol(grid)) {
            if (grid[row,col] == val) {
                xcoords[length(xcoords)+1] <- col
                ycoords[length(ycoords)+1] <- nrow(grid) - row + 1
            }
        }
    }
    return(list(xcoords,ycoords))
}

findRandomEmpty <- function(city) {
    empties <- which(city == EMPTY, arr.ind=TRUE)
    return(empties[sample.int(nrow(empties),1),])
}

computeAvgRatio <- function(city) {
    ratioSum <- 0
    numNonEmpty <- 0
    for (row in 1:nrow(city)) {
        for (col in 1:ncol(city)) {
            if (city[row,col] != EMPTY) {
                numNonEmpty <- numNonEmpty + 1
                ratioSum <- ratioSum +
                    computeRatio(city[row,col],city,row,col)
            }
        }
    }
    return (ratioSum / numNonEmpty)
}


plot.gen <- function(city,gen) {
    reds <- pointsForGrid(city[,,gen-1],RED)
    plot(reds[[1]],reds[[2]],pch=19,col="red",
        xlim=c(0,width+1),ylim=c(0,height+1),main=paste("Generation",gen),
        xlab="",ylab="")
    blues <- pointsForGrid(city[,,gen-1],BLUE)
    points(blues[[1]],blues[[2]],pch=19,col="blue",
        xlim=c(0,width+1),ylim=c(0,height+1))
}


# Main simulation.
starter <- runif(width * height)
config <- matrix(ifelse(starter < probRed, RED, 
    ifelse(starter < probRed + probBlue, BLUE,
    EMPTY)),nrow=height)

city <- array(dim=c(width,height,numGen))
city[,,1] <- config


for (gen in 2:numGen) {
    
    plot.gen(city,gen)

    city[,,gen] <- city[,,gen-1]

    for (row in seq(height)) {
        for (col in seq(width)) {
            curr.val <- city[row,col,gen-1]
            if(curr.val != EMPTY  &&  
                    belowThresh(curr.val, city[,,gen-1],row,col,thresh)) {
                city[row,col,gen] <- EMPTY
                randEmpty <- findRandomEmpty(city[,,gen])
                city[randEmpty[1],randEmpty[2],gen] <- curr.val
            }
        }
    }

}

cat("The average ratio is ", 
    round(computeAvgRatio(city[,,numGen]),2),".\n",sep="")
