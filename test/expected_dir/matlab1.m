matlab	comment	% PROGRAM theta_logistic.m
matlab	comment	%    Calculates by simulation the probability that a population
matlab	comment	%    following the theta logistic model and starting at Nc will fall
matlab	comment	%    below the quasi-extinction threshold Nx at or before time tmax
matlab	blank	
matlab	comment	% SIMULATION PARAMETERS
matlab	comment	% for butterflies (Euphydryas editha bayensis) at Jasper Ridge (population C)
matlab	blank	
matlab	code	r=0.3458;			% intrinsic rate of increase--Butterflies at Jasper Ridge
matlab	code	K=846.017;			% carrying capacity
matlab	code	theta=1;		    % nonlinearity in density dependence
matlab	code	sigma2=1.1151;		% environmental variance
matlab	code	Nc=94;				% starting population size
matlab	code	Nx=20;				% quasi-extinction threshold
matlab	code	tmax=20;			% time horizon
matlab	code	NumReps=50000;	    % number of replicate population trajectories
matlab	blank	
matlab	comment	% SIMULATION CODE
matlab	blank	
matlab	code	sigma=sqrt(sigma2);
matlab	code	randn('state',sum(100*clock));	% seed the random number generator
matlab	blank	
matlab	code	N=Nc*ones(1,NumReps);	% all NumRep populations start at Nc
matlab	code	NumExtant=NumReps;      % all populations are initially extant
matlab	code	Extant=[NumExtant];		% vector for number of extant pops. vs. time
matlab	blank	
matlab	code	for t=1:tmax,                           % For each future time,
matlab	code		N=N.*exp( r*( 1-(N/K).^theta )...   %   the theta logistic model
matlab	code		+ sigma*randn(1,NumExtant) );   %   with random environmental effects.
matlab	code		for i=NumExtant:-1:1,       % Then, looping over all extant populations,
matlab	code			if N(i)<=Nx,            %   if at or below quasi-extinction threshold,
matlab	code				N(i)=[];			%   delete the population.
matlab	code			end;
matlab	code		end;
matlab	code		NumExtant=length(N);	    %   Count remaining extant populations
matlab	code		Extant=[Extant NumExtant];  %   and store the result.
matlab	code	end;
matlab	blank	
matlab	comment	% OUTPUT CODE
matlab	comment	% ComputeS quasi-extinction probability as the fraction of replicate
matlab	comment	% populations that have hit the threshold by each future time,
matlab	comment	% and plotS quasi-extinction probability vs. time
matlab	blank	
matlab	code	ProbExtinct=(NumReps-Extant)/NumReps;
matlab	code	plot([0:tmax],ProbExtinct)
matlab	code	xlabel('Years into the future');
matlab	code	ylabel('Cumulative probability of quasi-extinction');
matlab	code	axis([0 tmax 0 1]);
matlab	blank	
matlab	comment	% Integrate solution exactly %
matlab	comment	% Options=[];
matlab	comment	% [T,true] = ode45(@logistic,[0,20],Nc,Options,r,K,theta);
matlab	comment	% subplot(1,2,2)
matlab	comment	% plot([1:tmax],P,'r.-',T,true,'g.-')
matlab	blank	
matlab	comment	 ... This is a seriously old-school comment.