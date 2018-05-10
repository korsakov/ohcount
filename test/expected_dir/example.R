r	comment	# Build a 'graph-like' object having 'nodes' nodes belonging to 'classes' classes.
r	comment	# Class distribution is given by 'proba', and connectivity probabilities are given
r	comment	# by 'intraproba' and 'interproba'.
r	code	generateGraph<-function(nodes,classes,proba=rep(1/classes,classes),
r	code				intraproba=0.1,crossproba=0.02)
r	code	{
r	code		mat_pi=CreateConnectivityMat(classes,intraproba,crossproba)
r	code		igraph=Fast2SimuleERMG(nodes,proba,mat_pi[1],mat_pi[2])
r	code		adjacency=get.adjacency(igraph$graph)
r	code		cmgraph=list(nodes=nodes,classes=classes,adjacency=adjacency,nodeclasses=igraph$node.classes,proba=proba,
r	code	                     intraproba=intraproba,crossproba=crossproba)
r	code		attr(cmgraph,'class')<-c('cmgraph')
r	code		cmgraph
r	code	}
r	blank	
r	comment	# Return explicit member names for the different attributes of graph objects.
r	code	labels.cmgraph<-function(object,...)
r	code	{
r	code		c("Nodes","Classes","Adjacency Matrix","Node Classification","Class Probability Distribution","Intra Class Edge Probability","Cross Class Edge Probability")
r	code	}
r	blank	
r	comment	# Override the summmary function for graph objects.
r	code	summary.cmgraph<-function(object,...) 
r	code	{
r	blank	
r	code		cat(c("Nodes                         : ",object$nodes,"\n",
r	code		      "Edges                         : ",length(which(object$adjacency!=0)),"\n",
r	code		      "Classes                       : ",object$classes,"\n",
r	code		      "Class Probability Distribution: ",object$proba,"\n"))
r	code	}
r	blank	
r	comment	# Override the plot function for graph objects.
r	code	plot.cmgraph<-function(x,...) 
r	code	{
r	code		RepresentationXGroup(x$adjacency,x$nodeclasses)
r	code	}
r	blank	
r	comment	# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
r	comment	# their values are drawn according to 2 distributions: one for vertices joining nodes of
r	comment	# the same class, and another for vertices joining nodes of different classes.
r	comment	# The two distributions have different means but a single standard deviation.  
r	code	generateCovariablesCondZ<-function(g,sameclustermean=0,otherclustermean=2,sigma=1) 
r	code	{
r	code		mu=CreateMu(g$classes,sameclustermean,otherclustermean)
r	code		res=SimDataYcondZ(g$nodeclasses,mu,sigma)
r	code		cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=mu,y=res)
r	code		attr(cmcovars,'class')<-c('cmcovarz','cmcovar')
r	code		cmcovars
r	code	}
r	blank	
r	comment	# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
r	comment	# their values are drawn according to 2 distributions: one for vertices joining nodes of
r	comment	# the same class, and another for vertices joining nodes of different classes.
r	comment	# The two distributions have different means but a single standard deviation.
r	comment	# This function generates two sets of covariables.
r	code	generateCovariablesCondXZ<-function(g,sameclustermean=c(0,3),otherclustermean=c(2,5),sigma=1) 
r	code	{
r	code		mux0=CreateMu(g$classes,sameclustermean[1],otherclustermean[1])
r	code		mux1=CreateMu(g$classes,sameclustermean[2],otherclustermean[2])
r	code		res=SimDataYcondXZ(g$nodeclasses,g$adjacency,mux0,mux1,sigma)
r	code		cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=c(mux0,mux1),y=res)
r	code		attr(cmcovars,'class')<-c('cmcovarxz','cmcovar')
r	code		cmcovars
r	code	}
r	blank	
r	blank	
r	comment	# Override the print function for a cleaner covariable output.
r	code	print.cmcovar<-function(x,...)
r	code	{
r	code		cat("Classes           : ",x$graph$classes,"\n",
r	code		    "Intra cluster mean: ",x$sameclustermean,"\n",
r	code		    "Cross cluster mean: ",x$otherclustermean,"\n",
r	code		    "Variance          : ",x$sigma,"\n",
r	code		    "Covariables       :\n",x$y,"\n")
r	code	}
r	blank	
r	blank	
r	comment	# Perform parameter estimation on 'graph' given the covariables 'covars'.
r	code	estimateCondZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
r	code	{
r	code		res=EMalgorithm(initialclasses,covars$y,graph$adjacency,maxiterations,FALSE,selfloops)
r	code		cmestimation=list(mean=res$MuEstimated,variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
r	code		attr(cmestimation,'class')<-c('cmestimationz')
r	code		cmestimation
r	code	}
r	blank	
r	comment	# Private generic estimation function used to allow various call conventions for estimation functions.
r	code	privateestimate<-function(covars,graph,maxiterations,initialclasses,selfloops,...) UseMethod("privateestimate")
r	blank	
r	comment	# Private estimation function used to allow various call conventions for estimation functions.
r	comment	# Override of generic function for single covariables. 
r	code	privateestimate.cmcovarz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
r	code	{
r	code		res=estimateCondZ(graph,covars,maxiterations,initialclasses,selfloops)
r	code		attr(res,'class')<-c(attr(res,'class'),'cmestimation')
r	code		res
r	blank	
r	code	}
r	blank	
r	comment	# Perform parameter estimation on 'graph' given the covariables 'covars'.
r	code	estimateCondXZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
r	code	{
r	comment		#resSimXZ = EMalgorithmXZ(TauIni,Y2,Adjacente,30,SelfLoop=FALSE)
r	code		res=EMalgorithmXZ(initialclasses,covars$y,graph$adjacency,maxiterations,selfloops)
r	code		cmestimation=list(mean=c(res$MuEstimated1,res$MuEstimated2),variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
r	code		attr(cmestimation,'class')<-c('cmestimationxz')
r	code		cmestimation
r	code	}
r	blank	
r	comment	# Private estimation function used to allow various call conventions for estimation functions.
r	comment	# Override of generic function for multiple covariables.
r	code	privateestimate.cmcovarxz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
r	code	{
r	code		res=estimateCondXZ(graph,covars,maxiterations,initialclasses,selfloops)
r	code		attr(res,'class')<-c(attr(res,'class'),'cmestimation')
r	code		res
r	code	}
r	blank	
r	comment	# Generic estimation function applicable to graphs with covariables.
r	code	estimate<-function(graph,covars,...) UseMethod("estimate")
r	blank	
r	comment	# Override of the generic estimation function. Performs the actual function dispatch depending on the class of covariables.
r	code	estimate.cmgraph<-function(graph,covars,maxiterations=20,initialclasses=t(rmultinom(size=1,prob=graph$proba,n=graph$nodes)),selfloops=FALSE,method=NULL,...)
r	code	{
r	code		if (length(method)  == 0) {
r	code			res=privateestimate(covars,graph,maxiterations,initialclasses,selfloops,...)
r	code		} else {
r	code			res=method(graph,covars,maxiterations,initialclasses,selfloops)
r	code			attr(res,'class')<-c(attr(res,'class'),'cmestimation')
r	code		}
r	code		res
r	code	}
r	blank	
r	comment	# Override of the generic pliot function for estimation results.
r	code	plot.cmestimation<-function(x,...)
r	code	{
r	code		par(mfrow = c(1,2))
r	code		plot(x$jexpected)
r	code		title("Expected value of J: Convergence criterion")
r	blank	
r	code		map=MAP(x$tau)
r	code		gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
r	code		title("Network with estimated classes")
r	blank	
r	code	}
r	blank	
r	comment	# Generic private ICL computation function for graphs and covariables.
r	code	privatecomputeICL<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops) UseMethod("privatecomputeICL")
r	blank	
r	blank	
r	comment	# Private ICL computation function for graphs with single covariables.
r	code	privatecomputeICL.cmcovarz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
r	code	{
r	code		res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
r	code		attr(res,'class')<-c('cmiclz')
r	code		res
r	blank	
r	code	}
r	blank	
r	comment	# Private ICL computation function for graphs with multiple covariables.
r	code	privatecomputeICL.cmcovarxz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
r	code	{
r	code		res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
r	code		attr(res,'class')<-c('cmiclxz')
r	code		res
r	code	}
r	blank	
r	blank	
r	comment	# Generic public ICL computation function applicable to graph objects.
r	code	computeICL<-function(graph,covars,qmin,qmax,...) UseMethod("computeICL")
r	blank	
r	comment	# Override of ICL computation function applicable to graph objects.
r	comment	# Performs the actual method dispatch to private functions depending on the type of covariables.
r	code	computeICL.cmgraph<-function(graph,covars,qmin,qmax,loops=10,maxiterations=20,selfloops=FALSE,...)
r	code	{
r	code		res=privatecomputeICL(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
r	code		res$qmin=qmin
r	code		res$qmax=qmax
r	code		res$graph=graph
r	code		res$covars=covars
r	code		attr(res,'class')<-c(attr(res,'class'),'cmicl')
r	code		res
r	code	}
r	blank	
r	comment	# Override of the plot function for results of ICL computation.
r	code	plot.cmicl<-function(x,...)
r	code	{
r	code		par(mfrow = c(1,2))
r	code		result=x$iclvalues	
r	code		maxi=which(max(result)==result)
r	code		plot(seq(x$qmin,x$qmax),result,type="b",xlab="Number of classes",ylab="ICL value")
r	code		points(maxi+x$qmin-1,result[maxi],col="red")
r	code		title("ICL curve")
r	code		best=x$EMestimation[[maxi+x$qmin-1]]
r	code		tau=best$TauEstimated
r	code		map=MAP(tau)
r	code		gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
r	code		title("Network with estimated classes")
r	code	}
r	blank	
