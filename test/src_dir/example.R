# Build a 'graph-like' object having 'nodes' nodes belonging to 'classes' classes.
# Class distribution is given by 'proba', and connectivity probabilities are given
# by 'intraproba' and 'interproba'.
generateGraph<-function(nodes,classes,proba=rep(1/classes,classes),
			intraproba=0.1,crossproba=0.02)
{
	mat_pi=CreateConnectivityMat(classes,intraproba,crossproba)
	igraph=Fast2SimuleERMG(nodes,proba,mat_pi[1],mat_pi[2])
	adjacency=get.adjacency(igraph$graph)
	cmgraph=list(nodes=nodes,classes=classes,adjacency=adjacency,nodeclasses=igraph$node.classes,proba=proba,
                     intraproba=intraproba,crossproba=crossproba)
	attr(cmgraph,'class')<-c('cmgraph')
	cmgraph
}

# Return explicit member names for the different attributes of graph objects.
labels.cmgraph<-function(object,...)
{
	c("Nodes","Classes","Adjacency Matrix","Node Classification","Class Probability Distribution","Intra Class Edge Probability","Cross Class Edge Probability")
}

# Override the summmary function for graph objects.
summary.cmgraph<-function(object,...) 
{
	
	cat(c("Nodes                         : ",object$nodes,"\n",
	      "Edges                         : ",length(which(object$adjacency!=0)),"\n",
	      "Classes                       : ",object$classes,"\n",
	      "Class Probability Distribution: ",object$proba,"\n"))
}

# Override the plot function for graph objects.
plot.cmgraph<-function(x,...) 
{
	RepresentationXGroup(x$adjacency,x$nodeclasses)
}

# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
# their values are drawn according to 2 distributions: one for vertices joining nodes of
# the same class, and another for vertices joining nodes of different classes.
# The two distributions have different means but a single standard deviation.  
generateCovariablesCondZ<-function(g,sameclustermean=0,otherclustermean=2,sigma=1) 
{
	mu=CreateMu(g$classes,sameclustermean,otherclustermean)
	res=SimDataYcondZ(g$nodeclasses,mu,sigma)
	cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=mu,y=res)
	attr(cmcovars,'class')<-c('cmcovarz','cmcovar')
	cmcovars
}

# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
# their values are drawn according to 2 distributions: one for vertices joining nodes of
# the same class, and another for vertices joining nodes of different classes.
# The two distributions have different means but a single standard deviation.
# This function generates two sets of covariables.
generateCovariablesCondXZ<-function(g,sameclustermean=c(0,3),otherclustermean=c(2,5),sigma=1) 
{
	mux0=CreateMu(g$classes,sameclustermean[1],otherclustermean[1])
	mux1=CreateMu(g$classes,sameclustermean[2],otherclustermean[2])
	res=SimDataYcondXZ(g$nodeclasses,g$adjacency,mux0,mux1,sigma)
	cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=c(mux0,mux1),y=res)
	attr(cmcovars,'class')<-c('cmcovarxz','cmcovar')
	cmcovars
}


# Override the print function for a cleaner covariable output.
print.cmcovar<-function(x,...)
{
	cat("Classes           : ",x$graph$classes,"\n",
	    "Intra cluster mean: ",x$sameclustermean,"\n",
	    "Cross cluster mean: ",x$otherclustermean,"\n",
	    "Variance          : ",x$sigma,"\n",
	    "Covariables       :\n",x$y,"\n")
}


# Perform parameter estimation on 'graph' given the covariables 'covars'.
estimateCondZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
{
	res=EMalgorithm(initialclasses,covars$y,graph$adjacency,maxiterations,FALSE,selfloops)
	cmestimation=list(mean=res$MuEstimated,variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
	attr(cmestimation,'class')<-c('cmestimationz')
	cmestimation
}

# Private generic estimation function used to allow various call conventions for estimation functions.
privateestimate<-function(covars,graph,maxiterations,initialclasses,selfloops,...) UseMethod("privateestimate")

# Private estimation function used to allow various call conventions for estimation functions.
# Override of generic function for single covariables. 
privateestimate.cmcovarz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
{
	res=estimateCondZ(graph,covars,maxiterations,initialclasses,selfloops)
	attr(res,'class')<-c(attr(res,'class'),'cmestimation')
	res

}

# Perform parameter estimation on 'graph' given the covariables 'covars'.
estimateCondXZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
{
	#resSimXZ = EMalgorithmXZ(TauIni,Y2,Adjacente,30,SelfLoop=FALSE)
	res=EMalgorithmXZ(initialclasses,covars$y,graph$adjacency,maxiterations,selfloops)
	cmestimation=list(mean=c(res$MuEstimated1,res$MuEstimated2),variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
	attr(cmestimation,'class')<-c('cmestimationxz')
	cmestimation
}

# Private estimation function used to allow various call conventions for estimation functions.
# Override of generic function for multiple covariables.
privateestimate.cmcovarxz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
{
	res=estimateCondXZ(graph,covars,maxiterations,initialclasses,selfloops)
	attr(res,'class')<-c(attr(res,'class'),'cmestimation')
	res
}

# Generic estimation function applicable to graphs with covariables.
estimate<-function(graph,covars,...) UseMethod("estimate")

# Override of the generic estimation function. Performs the actual function dispatch depending on the class of covariables.
estimate.cmgraph<-function(graph,covars,maxiterations=20,initialclasses=t(rmultinom(size=1,prob=graph$proba,n=graph$nodes)),selfloops=FALSE,method=NULL,...)
{
	if (length(method)  == 0) {
		res=privateestimate(covars,graph,maxiterations,initialclasses,selfloops,...)
	} else {
		res=method(graph,covars,maxiterations,initialclasses,selfloops)
		attr(res,'class')<-c(attr(res,'class'),'cmestimation')
	}
	res
}

# Override of the generic pliot function for estimation results.
plot.cmestimation<-function(x,...)
{
	par(mfrow = c(1,2))
	plot(x$jexpected)
	title("Expected value of J: Convergence criterion")

	map=MAP(x$tau)
	gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
	title("Network with estimated classes")

}

# Generic private ICL computation function for graphs and covariables.
privatecomputeICL<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops) UseMethod("privatecomputeICL")


# Private ICL computation function for graphs with single covariables.
privatecomputeICL.cmcovarz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
{
	res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
	attr(res,'class')<-c('cmiclz')
	res

}

# Private ICL computation function for graphs with multiple covariables.
privatecomputeICL.cmcovarxz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
{
	res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
	attr(res,'class')<-c('cmiclxz')
	res
}


# Generic public ICL computation function applicable to graph objects.
computeICL<-function(graph,covars,qmin,qmax,...) UseMethod("computeICL")

# Override of ICL computation function applicable to graph objects.
# Performs the actual method dispatch to private functions depending on the type of covariables.
computeICL.cmgraph<-function(graph,covars,qmin,qmax,loops=10,maxiterations=20,selfloops=FALSE,...)
{
	res=privatecomputeICL(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
	res$qmin=qmin
	res$qmax=qmax
	res$graph=graph
	res$covars=covars
	attr(res,'class')<-c(attr(res,'class'),'cmicl')
	res
}

# Override of the plot function for results of ICL computation.
plot.cmicl<-function(x,...)
{
	par(mfrow = c(1,2))
	result=x$iclvalues	
	maxi=which(max(result)==result)
	plot(seq(x$qmin,x$qmax),result,type="b",xlab="Number of classes",ylab="ICL value")
	points(maxi+x$qmin-1,result[maxi],col="red")
	title("ICL curve")
	best=x$EMestimation[[maxi+x$qmin-1]]
	tau=best$TauEstimated
	map=MAP(tau)
	gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
	title("Network with estimated classes")
}

