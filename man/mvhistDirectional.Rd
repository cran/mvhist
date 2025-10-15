\name{mvhistDirectional}
\alias{histDirectional}
\alias{histDirectionalQuantileThreshold}
\alias{histDirectionalAbsoluteThreshold}


%- Also NEED an '\alias' for EACH other topic documented here.
\title{Directional Histograms}
\description{Tabulate and plot directional histograms}
\usage{
histDirectional( x, k, p=2, plot.type="default", freq=TRUE, positive.only=FALSE, 
     report="summary", label.orthants=TRUE, normalize.by.area=FALSE, ... )
histDirectionalQuantileThreshold( x, probs=1, p=2, k=3, positive.only=FALSE, ... )
histDirectionalAbsoluteThreshold( x, thresholds=0, p=2, k=3, positive.only=FALSE,...)     
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{data in an (n x d) matrix; rows are d-dimensional data vectors
}
  \item{k}{number of subdivisions, i.e. directional cones
}
  \item{p}{power of p-norm
}
  \item{freq}{TRUE for a frequency histogram, FALSE for a relative frequency histogram.  See note about normalize.by.area
}
  \item{normalize.by.area}{if TRUE, then the counts are normalized by the surface area of the corresponding
simplex on the sphere.  This is useful since in general the surface area varies with the region and counts will vary 
accordingly.  In particular, isotropic data will not appear isotropic without setting this to TRUE.
If TRUE, the value of freq is ignored: the histogram always shows the ratio count/surface area
} 
  \item{plot.type}{type of plot, see details below
}
  \item{positive.only}{If TRUE, look only in the first orthant
}
  \item{report}{level of warning messages; one of "summary", "all", "none".
}
  \item{label.orthants}{If plot.type="index", this controls whether or not the orthants are labeled on the plot.
}
  \item{probs}{vector of probabilites specifying what fraction of the extremes to keep
}
  \item{thresholds}{vector of thresholds specifying cutoff for extremes to keep
}
  \item{\dots}{Optional arguments to plot
}
}
\details{Calculate and plot multivariate directional histograms. 

Each orthant is subdivided by a k-wise subdivision and cones are constructed from the 
origin through each subdivision (and contiuing to infinity).  The tally then counts 
how many data points are in each (infinite) cone. 

\code{histDirectional} plots a directional histogram for all the data, 
\code{histDirectionalQuantileThreshold} plots \code{m=length(probs)} directional histograms,
with plot i using the top probs[i] fraction of the data, 
\code{histDirectionalAbsoluteThreshold}  plots \code{m=length(cut.off)} directional histograms,
with plot i using the data above cut.off[i].

When thresholding is being done, distance from the origin is computed by using the p-norm;
p=2 is Euclidean distance.

'plot.type' values depend on the type of plot being used.  See possible values in \code{mvhist}.
}

\value{A plot is drawn (unless plot.type="none") and a list is returned invisibly.  See function
\code{mvhist} for the contents of that list.   When the dimension of the data is bigger than
2, a flat 2d graph is drawn, with bins grouped by orthant.  This may be useful to show
is data is concentrated in certain directions.  Orthants are labeled with a string
of pluses and minuses, e.g. ++-- means the first two coordinates are positive and the last
two are negative.
}

\section{Examples of directional histograms}{ 
\figure{mvhistCircle.png}

histSimplex example with plot.type="counts" 
 
\figure{mvhistCircle2.png}

histSimplex example with plot.type="pillars" 
}

\examples{
# some directional, heavy tailed 2-dim data  
n <- 1000
A <- matrix( c(1,2, 4,1), nrow=2,ncol=2)
x2 <- matrix( 0.0, nrow=n, ncol=2 )
for (i in 1:n) { 
  x2[i,] <- c( sum( A[1,] * (1/runif(1))), sum(A[2,] * (1/runif(1))) ) 
} 

# three dimensional positive data
x3 <- matrix( abs(rnorm(9000)), ncol=3 )

if( interactive() ){

# save graphical parameters; restore to original value at end of examples
oldpar <- par()

histDirectional( x3, k=3, positive.only=TRUE, col='blue', lwd=3 )

# show scatter plot of all daat, then directional histogram of 100%, then top 25%, 
#  and finally top 10%
dev.new(); par(mfrow=c(2,2))
plot(x2,main="Raw data",col='red')
histDirectionalQuantileThreshold( x2, probs=c(1,0.25,0.1), p=1, 
    positive.only=TRUE, col='green',lwd=3)
    
dev.new(); par(mfrow=c(2,2))
histDirectionalAbsoluteThreshold( x2, thresholds=c(0,50,100,200), p=1, 
    positive.only=TRUE, col='blue',lwd=3)

# two dimensional, isotropic
x <- matrix( rnorm(8000), ncol=2 )
histDirectional( x, k=2 )  # default plot.type="radial"
histDirectional( x, k=2, col='red',lwd=4 ) # tinker with color and line width
histDirectional( x, k=2, plot.type="index" )

# three dimensional positive data
x <- matrix( abs(rnorm(9000)), ncol=3 )
histDirectional( x, k=3, positive.only=TRUE, col='blue', lwd=3 )
histDirectional( x, k=2, plot.type="orthogonal", positive.only=TRUE, p=1 )


# three dimensional isotropic/radially symmetric
x <- matrix( rnorm(3000), ncol=3, nrow=1000 )

histDirectional( x, k=2 ) # default plot.type="radial"
histDirectional( x, k=2, plot.type="grayscale" )
histDirectional( x, k=2, plot.type="index" )


# compare frequency, relative freq. and normalized histograms
n <- 20000; d <- 3; k <- 2
x <- matrix( rnorm( n*d ), nrow=n, ncol=d )
dev.new(); par(mfrow=c(3,1),mar=c(4,4,2,1))
histDirectional( x, k, plot.type="index" )
title("omnidirectional data: frequency")
histDirectional( x, k, freq=FALSE, plot.type="index" )
title("omnidirectional data: relative frequency")
histDirectional( x, k, plot.type="index", normalize.by.area=TRUE )
title("omnidirectional data: frequency/surface.area")

# 3d data, first octant only
# second plot is a multiple of first; third plot normalizes by the area of
# the partition elements
dev.new(); par(mfrow=c(3,1),mar=c(4,4,2,1))
histDirectional( abs(x), k=3, positive.only=TRUE, plot.type="index" )
title("positive data: frequency")
histDirectional( abs(x), k=3, positive.only=TRUE, freq=FALSE, plot.type="index" )
title("positive data: relative frequency")
histDirectional( abs(x), k=3, positive.only=TRUE, plot.type="index", normalize.by.area=TRUE )
title("positive data: frequency/surface.area")

# 4 dimensional data
d <- 4; n <- 10000
x <- matrix( rnorm(d*n), nrow=n, ncol=d )
histDirectional( x, k=1 ) # orthants are identified by + and - signs
histDirectional( x, k=1, normalize.by.area=TRUE )
histRectangular( x, breaks=2 )

# restore user's graphical parameters
par(oldpar)
}
}
