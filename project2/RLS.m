function [thetahat,xhat]=RLS(y,M,lambda,delay)

% [thetahat,xhat]=rls(x,y,N,lambda)
%
%	y			- Data sequence
%	M			- Dimension of the parameter vector
%	lambda			- Forgetting factor
%	thetahat		- Matrix with estimates of theta. 
%				  Row n corresponds to time n-1
%	xhat			- Estimate of x for n=1
%   delay    -delay to be reference
%
%
%  rls: Recursive Least-Squares Estimation
%
% 	Estimator: xhat(n)=Y^{T}(n)thetahat(n-1)
%
%	thetahat is estimated using RLS. 
%
%	Initalization:	P(0)=10000*I, thetahat(0)=0
%
%     
%     Author: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize P, xhat and thetahat
N = length(y);
P = 1e4*eye(M);
Y = zeros(M,1);
xhat = zeros(N,1);
thetahat = zeros(M,N);
% Loop

for n=1:1:N

	% Generate Y(n). Set elements of Y that does not exist to zero
    if n>delay
        Y = [y(n-delay);Y(1:M-1)];
    end
	% Estimate of x
    xhat (n+1)= thetahat(: , n )' *Y;


	% Update K
    K= P*Y/(lambda+Y' *P * Y);


	% Update P
    P = 1/lambda*(P-K* Y' *P);


	% Update the n+1 row in the matrix thetahat which in the 
	% notation in the Lecture Notes corresponds to thetahat(n)
    if n<N
	    thetahat(: ,n+1)=thetahat(:,n)+K* (y(n+1)-xhat(n+1));
    end
end

% Shift thetahat one step so that row n corresponds to time n
xhat = xhat(1:N);
%thetahat=thetahat(2:M+1,:);
