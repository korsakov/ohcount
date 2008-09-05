R	comment	# Build a 'graph-like' object having 'nodes' nodes belonging to 'classes' classes.
R	comment	# Class distribution is given by 'proba', and connectivity probabilities are given
R	comment	# by 'intraproba' and 'interproba'.
R	code	generateGraph<-function(nodes,classes,proba=rep(1/classes,classes),
R	code				intraproba=0.1,crossproba=0.02)
R	code	{
R	code		mat_pi=CreateConnectivityMat(classes,intraproba,crossproba)
R	code		igraph=Fast2SimuleERMG(nodes,proba,mat_pi[1],mat_pi[2])
R	code		adjacency=get.adjacency(igraph$graph)
R	code		cmgraph=list(nodes=nodes,classes=classes,adjacency=adjacency,nodeclasses=igraph$node.classes,proba=proba,
R	code	                     intraproba=intraproba,crossproba=crossproba)
R	code		attr(cmgraph,'class')<-c('cmgraph')
R	code		cmgraph
R	code	}
R	blank	
R	comment	# Return explicit member names for the different attributes of graph objects.
R	code	labels.cmgraph<-function(object,...)
R	code	{
R	code		c("Nodes","Classes","Adjacency Matrix","Node Classification","Class Probability Distribution","Intra Class Edge Probability","Cross Class Edge Probability")
R	code	}
R	blank	
R	comment	# Override the summmary function for graph objects.
R	code	summary.cmgraph<-function(object,...) 
R	code	{
R	blank	
R	code		cat(c("Nodes                         : ",object$nodes,"\n",
R	code		      "Edges                         : ",length(which(object$adjacency!=0)),"\n",
R	code		      "Classes                       : ",object$classes,"\n",
R	code		      "Class Probability Distribution: ",object$proba,"\n"))
R	code	}
R	blank	
R	comment	# Override the plot function for graph objects.
R	code	plot.cmgraph<-function(x,...) 
R	code	{
R	code		RepresentationXGroup(x$adjacency,x$nodeclasses)
R	code	}
R	blank	
R	comment	# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
R	comment	# their values are drawn according to 2 distributions: one for vertices joining nodes of
R	comment	# the same class, and another for vertices joining nodes of different classes.
R	comment	# The two distributions have different means but a single standard deviation.  
R	code	generateCovariablesCondZ<-function(g,sameclustermean=0,otherclustermean=2,sigma=1) 
R	code	{
R	code		mu=CreateMu(g$classes,sameclustermean,otherclustermean)
R	code		res=SimDataYcondZ(g$nodeclasses,mu,sigma)
R	code		cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=mu,y=res)
R	code		attr(cmcovars,'class')<-c('cmcovarz','cmcovar')
R	code		cmcovars
R	code	}
R	blank	
R	comment	# Generate covariable data for the graph 'g'. Covariables are associated to vertex data, and
R	comment	# their values are drawn according to 2 distributions: one for vertices joining nodes of
R	comment	# the same class, and another for vertices joining nodes of different classes.
R	comment	# The two distributions have different means but a single standard deviation.
R	comment	# This function generates two sets of covariables.
R	code	generateCovariablesCondXZ<-function(g,sameclustermean=c(0,3),otherclustermean=c(2,5),sigma=1) 
R	code	{
R	code		mux0=CreateMu(g$classes,sameclustermean[1],otherclustermean[1])
R	code		mux1=CreateMu(g$classes,sameclustermean[2],otherclustermean[2])
R	code		res=SimDataYcondXZ(g$nodeclasses,g$adjacency,mux0,mux1,sigma)
R	code		cmcovars=list(graph=g,sameclustermean=sameclustermean,otherclustermean=otherclustermean,sigma=sigma,mu=c(mux0,mux1),y=res)
R	code		attr(cmcovars,'class')<-c('cmcovarxz','cmcovar')
R	code		cmcovars
R	code	}
R	blank	
R	blank	
R	comment	# Override the print function for a cleaner covariable output.
R	code	print.cmcovar<-function(x,...)
R	code	{
R	code		cat("Classes           : ",x$graph$classes,"\n",
R	code		    "Intra cluster mean: ",x$sameclustermean,"\n",
R	code		    "Cross cluster mean: ",x$otherclustermean,"\n",
R	code		    "Variance          : ",x$sigma,"\n",
R	code		    "Covariables       :\n",x$y,"\n")
R	code	}
R	blank	
R	blank	
R	comment	# Perform parameter estimation on 'graph' given the covariables 'covars'.
R	code	estimateCondZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
R	code	{
R	code		res=EMalgorithm(initialclasses,covars$y,graph$adjacency,maxiterations,FALSE,selfloops)
R	code		cmestimation=list(mean=res$MuEstimated,variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
R	code		attr(cmestimation,'class')<-c('cmestimationz')
R	code		cmestimation
R	code	}
R	blank	
R	comment	# Private generic estimation function used to allow various call conventions for estimation functions.
R	code	privateestimate<-function(covars,graph,maxiterations,initialclasses,selfloops,...) UseMethod("privateestimate")
R	blank	
R	comment	# Private estimation function used to allow various call conventions for estimation functions.
R	comment	# Override of generic function for single covariables. 
R	code	privateestimate.cmcovarz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
R	code	{
R	code		res=estimateCondZ(graph,covars,maxiterations,initialclasses,selfloops)
R	code		attr(res,'class')<-c(attr(res,'class'),'cmestimation')
R	code		res
R	blank	
R	code	}
R	blank	
R	comment	# Perform parameter estimation on 'graph' given the covariables 'covars'.
R	code	estimateCondXZ<-function(graph,covars,maxiterations,initialclasses,selfloops) 
R	code	{
R	comment		#resSimXZ = EMalgorithmXZ(TauIni,Y2,Adjacente,30,SelfLoop=FALSE)
R	code		res=EMalgorithmXZ(initialclasses,covars$y,graph$adjacency,maxiterations,selfloops)
R	code		cmestimation=list(mean=c(res$MuEstimated1,res$MuEstimated2),variance=res$VarianceEstimated,pi=res$PIEstimated,alpha=res$AlphaEstimated,tau=res$TauEstimated,jexpected=res$EJ,graph=graph)
R	code		attr(cmestimation,'class')<-c('cmestimationxz')
R	code		cmestimation
R	code	}
R	blank	
R	comment	# Private estimation function used to allow various call conventions for estimation functions.
R	comment	# Override of generic function for multiple covariables.
R	code	privateestimate.cmcovarxz<-function(covars,graph,maxiterations,initialclasses,selfloops,...)
R	code	{
R	code		res=estimateCondXZ(graph,covars,maxiterations,initialclasses,selfloops)
R	code		attr(res,'class')<-c(attr(res,'class'),'cmestimation')
R	code		res
R	code	}
R	blank	
R	comment	# Generic estimation function applicable to graphs with covariables.
R	code	estimate<-function(graph,covars,...) UseMethod("estimate")
R	blank	
R	comment	# Override of the generic estimation function. Performs the actual function dispatch depending on the class of covariables.
R	code	estimate.cmgraph<-function(graph,covars,maxiterations=20,initialclasses=t(rmultinom(size=1,prob=graph$proba,n=graph$nodes)),selfloops=FALSE,method=NULL,...)
R	code	{
R	code		if (length(method)  == 0) {
R	code			res=privateestimate(covars,graph,maxiterations,initialclasses,selfloops,...)
R	code		} else {
R	code			res=method(graph,covars,maxiterations,initialclasses,selfloops)
R	code			attr(res,'class')<-c(attr(res,'class'),'cmestimation')
R	code		}
R	code		res
R	code	}
R	blank	
R	comment	# Override of the generic pliot function for estimation results.
R	code	plot.cmestimation<-function(x,...)
R	code	{
R	code		par(mfrow = c(1,2))
R	code		plot(x$jexpected)
R	code		title("Expected value of J: Convergence criterion")
R	blank	
R	code		map=MAP(x$tau)
R	code		gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
R	code		title("Network with estimated classes")
R	blank	
R	code	}
R	blank	
R	comment	# Generic private ICL computation function for graphs and covariables.
R	code	privatecomputeICL<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops) UseMethod("privatecomputeICL")
R	blank	
R	blank	
R	comment	# Private ICL computation function for graphs with single covariables.
R	code	privatecomputeICL.cmcovarz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
R	code	{
R	code		res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
R	code		attr(res,'class')<-c('cmiclz')
R	code		res
R	blank	
R	code	}
R	blank	
R	comment	# Private ICL computation function for graphs with multiple covariables.
R	code	privatecomputeICL.cmcovarxz<-function(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
R	code	{
R	code		res=ICL(X=graph$adjacency,Y=covars$y,Qmin=qmin,Qmax=qmax,loop=loops,NbIteration=maxiterations,SelfLoop=selfloops,Plot=FALSE)
R	code		attr(res,'class')<-c('cmiclxz')
R	code		res
R	code	}
R	blank	
R	blank	
R	comment	# Generic public ICL computation function applicable to graph objects.
R	code	computeICL<-function(graph,covars,qmin,qmax,...) UseMethod("computeICL")
R	blank	
R	comment	# Override of ICL computation function applicable to graph objects.
R	comment	# Performs the actual method dispatch to private functions depending on the type of covariables.
R	code	computeICL.cmgraph<-function(graph,covars,qmin,qmax,loops=10,maxiterations=20,selfloops=FALSE,...)
R	code	{
R	code		res=privatecomputeICL(covars,graph,qmin,qmax,loops,maxiterations,selfloops)
R	code		res$qmin=qmin
R	code		res$qmax=qmax
R	code		res$graph=graph
R	code		res$covars=covars
R	code		attr(res,'class')<-c(attr(res,'class'),'cmicl')
R	code		res
R	code	}
R	blank	
R	comment	# Override of the plot function for results of ICL computation.
R	code	plot.cmicl<-function(x,...)
R	code	{
R	code		par(mfrow = c(1,2))
R	code		result=x$iclvalues	
R	code		maxi=which(max(result)==result)
R	code		plot(seq(x$qmin,x$qmax),result,type="b",xlab="Number of classes",ylab="ICL value")
R	code		points(maxi+x$qmin-1,result[maxi],col="red")
R	code		title("ICL curve")
R	code		best=x$EMestimation[[maxi+x$qmin-1]]
R	code		tau=best$TauEstimated
R	code		map=MAP(tau)
R	code		gplot(x$graph$adjacency,vertex.col=map$node.classes+2)
R	code		title("Network with estimated classes")
R	code	}
R	blank	
