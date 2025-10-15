\name{mvhist}
\alias{mvhist-package}
\alias{histSimplex}
\alias{histRectangular}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{Multivariate Histograms}
\description{Tabulate and plot histograms for multivariate data, including directional histograms.
This package used to be part of the \code{\link[mvmesh]{mvmesh}} package, which works with multivariate meshes and grids.
To simplify that package and make these functions more visible, this package was extracted as
a self-standing package in Septemeber 2023.  The functions provided can tally the number of data points in
a list of regions in dimensions two or more.  All regions/bins have flat sides.

Version 1.2 (2025-10-15) makes a few changes in this documentation; no functions have changed.

Several different plots are available to show 
2 and 3 dimensional data; and one can deal with dimension greater than 3. 
Plots in 3d can be rotated and zoomed in/out with the mouse, as well as resized. }

\usage{
histRectangular( x, breaks=10, plot.type="default", freq=TRUE, report="summary", ... )
histSimplex( x, S, plot.type="default", freq=TRUE, report="summary", ... )
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{data in an (n x d) matrix; rows are d-dimensional data vectors
}
  \item{freq}{TRUE for a frequency histogram, FALSE for a relative frequency histogram.  See note about normalize.by.area
}
  \item{breaks}{specifes the subdivision of the region; see 'breaks' in \code{\link[mvmesh]{SolidRectangle}} in package \code{\link[mvmesh]{mvmesh}}.
}
  \item{plot.type}{type of plot, see details below
}
  \item{S}{(vps x d x nS) array of simplices in the V-representation, see \code{\link[mvmesh]{V2Hrep}} in package \code{\link[mvmesh]{mvmesh}}.
 The vector S[,i,j] gives the coordinates of the i-th vertex of the j-th simplex. 
}

  \item{report}{level of warning messages; one of "summary", "all", "none".
}
  \item{\dots}{Optional arguments to plot, e.g. color="red", etc.
}
}
\details{Calculate and plot multivariate histograms.  
\code{histRectangular} plots histogram based on a rectangular grid, while
\code{histSimplex} plots histogram based on the simplices specified in \code{S},

These routines use the functions and conventions of the package \code{\link[mvmesh]{mvmesh}}.  In particular, 
shapes can be described in two formats: vertex representation or half-space representation,
respectively called the V-representation or H-representation.  
In all cases, the bins are simplices are converted to the H-representation and tallied by \code{TallyHrep}.

'plot.type' values depend on the type of plot being used.  Possible values are:
\itemize{
\item "none" - does not show a plot, just return the counts.  This is useful to summarize
   data and in higher dimensions where no plot is useful
\item "index" - shows a histogram of simplex index number versus count, does not show the 
   geometry, but works in any dimension
\item "pillars" - shows a 3D plot with pillars/columns having base the shape of the 
   simplices and height proportional to frequency counts.
   When the points are 2D, this works for \code{histRectangular} and \code{histSimplex}; when the points are 3D, this only
   works for \code{histRectangular}.  \code{DrawPillars} is used to plot the pillars.
\item "counts" - shows frequency counts as a number in the center of each simplex
\item "radial" - \code{histDirectional} only, shows radial spikes proportional to the counts 
\item "grayscale" - \code{histDirectional} only, color codes simplices proportional to the counts 
\item "orthogonal" - \code{histDirectional} only, shows radial spikes proportional to the counts 
\item "default" - type depends on the dimension of the data and type of histogram
}
}
\value{A plot is drawn (unless plot.type="none").  Note that the plots may be underneath/behind other
windows; if you don't see a plot, search your desktop and/or the plot tab.  A list is returned invisibly, 
with the following fields:
\itemize{
\item counts - frequency count in each bin
\item nrejects - number of x values not in any bin
\item nties - number of points in more than one bin (if bins are set up to be non-overlapping, 
   this should only occur on a shared edge between two simplices)
\item nx - total number of data points in x
\item rel.freq - counts/nx
\item rel.rejects - nrejects/nx
\item mesh - object of type mvmesh, see \code{\link[mvmesh]{mvmesh}}
\item plot.type - input value
\item report - input value
}
While counting data points in the different bins, two issues can arrise: (a) a data point 
is on the boundary of a bin, or (b) a data point is not in any of the specified bins.  
If report="none", no report is given about these issues.  If report="summary", a count is 
given of the number of ties and the number of rejects.  
If report="all", the count of number of ties and rejects is given, and the indices 
(rows of the data matrix) of the rejected points are given. }

\section{Warning}{These functions use double precision numbers by default, and most real numbers cannot be
expressed exactly as doubles.  So testing for being on a boundary is subject to the usual issues with floating point numbers. 
This is why the message "If you want correct answers, use rational arithmetic." is given when the
package \code{rcdd} is loaded.  

It is possible, but takes some work, to specify regions using only rational numbers
as coordinates, and if the data is rational, you will be able to exactly specify regions and possibily boundaries.
See the help for packages \code{\link[mvmesh]{mvmesh}} and \code{rcdd}.  Using rational coordinates 
has not be tested in this package.}


\section{Example of histRectangular}{ 
\figure{mvhistRectangle.png}
}

\examples{
#  isotropic data in 2 and 3 dimensions
x2d <- matrix( rnorm(8000), ncol=2 )
x3d <- matrix( rnorm(9000), ncol=3 )

# 3d plots are in separate windows opened by the rgl package; you may have 
#    to search on the desktop to find those windows
if( interactive() ){

# save graphical parameters; restore to original value at end of examples
oldpar <- par()

# simple histogram of 2d data
histRectangular( x2d, breaks=5); title3d("2d, default plot.type" )

# simple histogram of 3d data: slices of data are stacked
histRectangular( x3d, breaks=4 ); title3d("3d, default plot.type" )

histRectangular( x2d, breaks=5, col='blue', plot.type="pillars" )
histRectangular( x2d, breaks=5, plot.type="counts" )
histRectangular( x2d, breaks=5, plot.type="index" )

# count number of data points in a triangle, using mvmesh function to define the partition
S1 <- 4*SolidSimplex( n=2, k=3 )$S
histSimplex( x2d, S1, plot.type="counts" )  # note many rejects
histSimplex( x2d, S1, col="green", lwd=3 ) # default plot.type="pillars"

# partiton a ball
S2 <- 4*UnitBall( n=2, k=2 )$S
histSimplex( x2d, S2, plot.type="counts", col="purple" )
histSimplex( x2d, S2, col="red" )

# Specify simplices explicitly to get specific region, e.g. restrict to x[1] >= 0
S1 <- matrix( c(0,0,  10,0,  0,10, 10,10), ncol=2, byrow=TRUE )  # first quadrant (bounded)
S2 <- matrix( c(0,0,  10,0,  0,-10,  10,-10), ncol= 2,, byrow=TRUE ) # fourth quadrant (bounded)
S <- array( c(S1,S2), dim=c(4,2,2) )
simp <- histSimplex( x2d, S, plot.type="counts" )
text(2,9, paste("nrejects=",simp$nrejects), col='red' )

# check behavior with rejects and ties
r <- histSimplex( x2d, S, plot.type="counts" )
str(r)  # see list of returned values
sum(c(r$counts,r$nrejects))

# restore user's graphical parameters
par(oldpar)
}
}

