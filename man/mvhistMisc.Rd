\name{mvhistMisc}
\alias{TallyHrep}
\alias{DrawPillars}
\alias{HrepCones}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{Miscellaneous  routines for multivariate histograms}
\description{Utility functions for multivariate histograms}
\usage{
TallyHrep( x, H, report="summary" )  
DrawPillars( S, height, shift=rep(0.0,3), ... )
HrepCones( S )
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{data in an (n x d) matrix; rows are d-dimensional data vectors
}
  \item{S}{(vps x d x nS) array of simplices in V representation, see \code{\link{V2Hrep}}
}
  \item{H}{array of simplices in H representation, see \code{\link{V2Hrep}}
}
  \item{report}{what information to return for tally}
  \item{height}{height of the pillars}
  \item{shift}{(x,y,z) shift of the pillars }   
  \item{\dots}{Optional arguments to plot, e.g. color="red", etc.}  
}
\details{Internal functions for multivariate histograms.  

\code{TallyHrep} tallies the number of data points in each simplex of the H representation.

\code{DrawPillars} plot 3d pillars/columns to show histogram height.

\code{HrepCones} computes an (m x (d+2) x ncones) array H, with H[,,k] giving the 
     H-representation of the k-th cone,
}

\value{
\code{TallyHrep} returns a list containing the number of data points in each simplex.

\code{DrawPillars} draws 3d pillars/columns to show histogram height.

\code{HrepCones} an (m x (d+2) x ncones) array H, with H[,,k] giving the 
     H-representation of the k-th cone.
}

