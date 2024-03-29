% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dantzig.delta.R
\name{dantzig.delta}
\alias{dantzig.delta}
\title{Dantzig selector with an option to make profile plot}
\source{
Cand{\`e}s, E. and Tao, T. (2007). The Dantzig selector: Statistical estimation when p is much
larger than n. Annals of Statistics 35 (6), 2313--2351.

Phoa, F. K., Pan, Y. H. and Xu, H. (2009). Analysis of supersaturated
designs via the Dantzig selector. Journal of Statistical Planning and Inference
139 (7), 2362--2372.
}
\usage{
dantzig.delta(X, y, delta, plot = FALSE)
}
\arguments{
\item{X}{a design matrix.}

\item{y}{a vector of  responses.}

\item{delta}{a vector with the values of \code{delta} for which the DS
optimization needs to be solved.}

\item{plot}{a boolean value of either TRUE or FALSE with TRUE
indicating that the profile plot should be drawn.}
}
\value{
A matrix of the estimated values of \code{beta} with each
row corresponding to a particular value of \code{delta}.
}
\description{
The Dantzig selector (DS) finds a solution for the model parameters
of a linear model, \code{beta} using linear programming. For a given \code{delta},
DS minimizes the L_1-norm (sum of absolute values) of \code{beta} subject to the constraint
that \code{max(|t(X)(y-X * beta)|) <= delta}.
}
\examples{
data(dataHamadaWu)
X = dataHamadaWu[,-8]
Y = dataHamadaWu[,8]
#scale and center X and y
scaleX = base::scale(X, center= TRUE, scale = TRUE)
scaleY = base::scale(Y, center= TRUE, scale = FALSE)
maxDelta = max(abs(t(scaleX)\%*\%matrix(scaleY, ncol=1)))
# Dantzig Selector on 4 equally spaced delta values between 0 and maxDelta
dantzig.delta(scaleX, scaleY, delta = seq(0,maxDelta,length.out=4)) 

}
\seealso{
\code{\link{GDS_givencols}}, \code{\link{GDSARM}}
}
