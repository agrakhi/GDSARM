#' Gauss-Dantzig Selector - Aggregation over Random Models (GDS-ARM)
#'
#' @description The GDS-ARM procedure consists of three steps. First, it runs 
#' the Gauss Dantzig Selector (GDS) \code{nrep} times, each time 
#' with a different set of \code{nint} randomly selected two-factor interactions.
#' All \code{m} main effects are included in each GDS run. Second, the best
#' \code{ntop} models are identified with the smallest BIC. Effects that 
#' appear in at least \code{pkeep x ntop} of the \code{ntop} 
#' models are then passed on to the third stage. In the third stage, stepwise 
#' regression is used. With 
#' \code{n} being the number of runs, the stepwise regression starts
#' with at most \code{n-3} selected effects from the previous step. The 
#' remaining effects from the previous step as well as all main effects are
#' given a chance to enter into the model using the forward-backward stepwise
#' regression. The function also has the option of using the modified GDS-ARM. 
#' The modified version incorporates effect heredity in two steps, first, for 
#' each model found by GDS, we ignore active interactions when at least one of 
#' the main effects is not active (for weak heredity) or when both main effects are not
#' active (for strong heredity); and second, we do the same for the model found 
#' after the stepwise stage of GDS-ARM.
#' 
#' @param delta.n a positive integer suggesting the number of delta values
#' to be tried. \code{delta.n} equally spaced values of \code{delta} will be used 
#' strictly between 0 and \code{max(|t(X)y|)}. The default value is set to 10.
#' 
#' @param nint a positive integer representing the number of randomly 
#' chosen interactions in each GDS run. The suggested value to use is the ceiling of 20% 
#' of the total number of interactions, that is, for \code{m} factors, we have
#' \code{ceiling(0.2(m choose 2))}.
#' 
#' @param nint a positive integer representing the number of randomly 
#' chosen interactions. The suggested value to use is the ceiling of 20% 
#' of the total number of interactions, that is, for \code{m} factors, we have
#' \code{ceiling(0.2(m choose 2))}.
#' 
#' @param nrep a positive integer representing the number of times GDS should
#' be run. The suggested value is \code{(m choose 2)}.
#' 
#' @param ntop a positive integer representing the number of top models 
#' to be selected among the \code{nrep} models. The suggested value is 
#' \code{max(20, (nrep x nint)/(m(m-1))}. The value of \code{ntop} should not exceed \code{nrep}.
#' 
#' @param pkeep a number between 0 and 1 representing the proportion of \code{ntop}
#' models in which an effect needs to appear in order to be selected for the stepwise regression stage.
#' 
#' @param design a \eqn{n \times m}{n x m} matrix of \code{m} two-level factors. 
#' The levels should be coded as +1 and -1.
#' 
#' @param Y a vector of \code{n} responses.
#' 
#' @param cri.penter the p-value cutoff for the most significant effect to enter into the 
#' stepwise regression model. The suggested value is 0.01.
#' 
#' @param cri.premove the p-value cutoff for the least significant effect to exit from the 
#' stepwise regression model. The suggested value is 0.05.
#' 
#' @param opt.heredity a string with either `none`, or `weak`, or `strong`. Denotes
#' whether the effect-heredity (weak or strong) should be embedded in GDS-ARM. 
#' The default value is `none` as suggested in Singh and Stufken (2022).
#' 
#' @param seedvalue a seed value that will fix the set of interactions being 
#' selected. The default value is seed to 1234.
#'
#' @return A list returning the selected effects as well as the
#' corresponding important factors.
#' 
#' @source Cand{\`e}s, E. and Tao, T. (2007). The Dantzig selector: Statistical estimation when p is much
#' larger than n. Annals of Statistics 35 (6), 2313--2351.
#' 
#' @source Dopico-Garc{\' i}a, M.S., Valentao, P., Guerra, L., Andrade, P. B., and Seabra, R. M. (2007).
#' Experimental design for extraction and quantification of phenolic 
#' compounds and organic acids in white "Vinho Verde" grapes 
#' Analytica Chimica Acta, 583(1): 15--22.
#' 
#' @source Hamada, M. and Wu, C. F. J. (1992). Analysis of designed experiments 
#' with complex aliasing. Journal of Quality Technology 24 (3), 130--137.
#' 
#' @source Hunter, G. B., Hodi, F. S. and Eagar, T. W. (1982). High cycle fatigue of weld repaired
#' cast Ti-6AI-4V. Metallurgical Transactions A 13 (9), 1589--1594.
#'
#' @source Phoa, F. K., Pan, Y. H. and Xu, H. (2009). Analysis of supersaturated 
#' designs via the Dantzig selector. Journal of Statistical Planning and Inference
#' 139 (7), 2362--2372.
#' 
#' @source Singh, R. and Stufken, J. (2022). Factor selection in screening experiments
#' by aggregation over random models, 1--31. \doi{10.48550/arXiv.2205.13497}
#' 
#' @seealso \code{\link{GDS_givencols}}, \code{\link{dantzig.delta}}
#'
#' @examples
#' data(dataHamadaWu)
#' X = dataHamadaWu[,-8]
#' Y = dataHamadaWu[,8]
#' delta.n = 10
#' n = dim(X)[1]
#' m = dim(X)[2]
#' nint = ceiling(0.2*choose(m,2))
#' nrep = choose(m,2)
#' ntop = max(20, nint*nrep/(2*choose(m,2)))
#' pkeep = 0.25 
#' cri.penter = 0.01
#' cri.premove = 0.05
#' design = X
#' # GDS-ARM with default values
#' GDSARM(delta.n, nint, nrep, ntop, pkeep, X, Y, cri.penter, cri.premove)
#' 
#' # GDS-ARM with default values but with weak heredity
#' opt.heredity="weak" 
#' GDSARM(delta.n, nint, nrep, ntop, pkeep, X, Y, cri.penter, cri.premove, opt.heredity)
#' 
#' 
#' data(dataCompoundExt)
#' X = dataCompoundExt[,-9]
#' Y = dataCompoundExt[,9]
#' delta.n = 10
#' n = dim(X)[1]
#' m = dim(X)[2]
#' nint = ceiling(0.2*choose(m,2))
#' nrep = choose(m,2)
#' ntop = max(20, nint*nrep/(2*choose(m,2)))
#' pkeep = 0.25 
#' cri.penter = 0.01
#' cri.premove = 0.05
#' design = X
#' # GDS-ARM on compound extraction
#' GDSARM(delta.n, nint, nrep, ntop, pkeep, X, Y, cri.penter, cri.premove)
#' 
#' # GDS-ARM on compound extraction with strong heredity
#' opt.heredity = "strong"
#' GDSARM(delta.n, nint, nrep, ntop, pkeep, X, Y, cri.penter, cri.premove, opt.heredity)
#' 
#' 
#' @export
#'

GDSARM<- function(delta.n=10, nint, nrep, ntop, pkeep, design, Y, cri.penter=0.01, cri.premove=0.05, opt.heredity=c("none"), seedvalue=1234){
  n = dim(design)[1]
  m = dim(design)[2]
  artificial.response <- stats::rnorm(n,0,1)

  set.seed(seedvalue) 
  
  Xall <- as.data.frame(stats::model.matrix(stats::lm(artificial.response ~ .^2, design)))[,-1]
  Xall.scale = as.data.frame(base::scale(Xall,center = T,scale = T)) #*(1/sqrt(n-1))*(0.2)^12
  Xmain = Xall.scale[, c(1:m)]
  Xint = Xall.scale[,-c(1:m) ]

        # step I: run many GDS models
        StepIResults = StepI_chooseints(delta.n, nint, nrep, Xmain, Xint, Y, opt.heredity)

        #selecting the top ntop models
        TopNtopModels=base::order(StepIResults$BIC)[1:ntop]
        SelectedEffectsFromTopnNmodels = StepIResults$output[TopNtopModels,]

        # counting frequencies as per columns
        FreqSelectedEffects=base::table(SelectedEffectsFromTopnNmodels)
        FreqSelectedEffects = base::sort(FreqSelectedEffects, decreasing = T)
        select = names(FreqSelectedEffects[which(FreqSelectedEffects>=pkeep*ntop)])

        # step III: stepwise
         if (length(select) < (n-2)){
            xstartmodel=gsub(":", "a",select)
            xaddall = unique(c(xstartmodel,colnames(Xmain)))
            xremain = xaddall[-(1:length(xstartmodel))]
            xaddall = unique(xaddall)
            xremain = unique(xremain)
          } else{
            xstartmodel=gsub(":", "a",select)[1:(n-3)]
            xaddall = unique(c(xstartmodel,gsub(":", "a",select)[-(1:(n-3))],colnames(Xmain)))
            xremain = xaddall[-(1:length(xstartmodel))]
            xaddall = unique(xaddall)
            xremain = unique(xremain)
          }
          OutputStepwise = StepIII_stepwise(xstartmodel,xremain,Xmain, Xint, Y,cri.penter, cri.premove,opt.heredity)
    return(OutputStepwise)
}
