% PROGRAM theta_logistic.m
%    Calculates by simulation the probability that a population
%    following the theta logistic model and starting at Nc will fall
%    below the quasi-extinction threshold Nx at or before time tmax

% SIMULATION PARAMETERS
% for butterflies (Euphydryas editha bayensis) at Jasper Ridge (population C)

r=0.3458;			% intrinsic rate of increase--Butterflies at Jasper Ridge
K=846.017;			% carrying capacity
theta=1;		    % nonlinearity in density dependence
sigma2=1.1151;		% environmental variance
Nc=94;				% starting population size
Nx=20;				% quasi-extinction threshold
tmax=20;			% time horizon
NumReps=50000;	    % number of replicate population trajectories

% SIMULATION CODE

sigma=sqrt(sigma2);
randn('state',sum(100*clock));	% seed the random number generator

N=Nc*ones(1,NumReps);	% all NumRep populations start at Nc
NumExtant=NumReps;      % all populations are initially extant
Extant=[NumExtant];		% vector for number of extant pops. vs. time

for t=1:tmax,                           % For each future time,
	N=N.*exp( r*( 1-(N/K).^theta )...   %   the theta logistic model
	+ sigma*randn(1,NumExtant) );   %   with random environmental effects.
	for i=NumExtant:-1:1,       % Then, looping over all extant populations,
		if N(i)<=Nx,            %   if at or below quasi-extinction threshold,
			N(i)=[];			%   delete the population.
		end;
	end;
	NumExtant=length(N);	    %   Count remaining extant populations
	Extant=[Extant NumExtant];  %   and store the result.
end;

% OUTPUT CODE
% ComputeS quasi-extinction probability as the fraction of replicate
% populations that have hit the threshold by each future time,
% and plotS quasi-extinction probability vs. time

ProbExtinct=(NumReps-Extant)/NumReps;
plot([0:tmax],ProbExtinct)
xlabel('Years into the future');
ylabel('Cumulative probability of quasi-extinction');
axis([0 tmax 0 1]);

% Integrate solution exactly %
% Options=[];
% [T,true] = ode45(@logistic,[0,20],Nc,Options,r,K,theta);
% subplot(1,2,2)
% plot([1:tmax],P,'r.-',T,true,'g.-')

 ... This is a seriously old-school comment.