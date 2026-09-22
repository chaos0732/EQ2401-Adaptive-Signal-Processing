function [thetahat,xhat]=LMS(y,M,muu,delay) 

% [thetahat,xhat]=lms(x,y,N,muu)
%
%	y			- Data sequence
%	M			- Dimension of the parameter vector
%	muu			- Step sizeS
%	thetahat		- Matrix with estimates of theta. 
%				  Row n corresponds to the estimate thetahat(n)'
%	xhat			- Estimate of x
%      delay        -delay time
%
%
%  lms: The Least-Mean Square Algorithm
%
% 	Estimator: xhat(n)=Y^{T}(n)thetahat(n-1)
%
%	thetahat is estimated using LMS. 
%
%     
%     Author: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize xhat and thetahat
N = length(y);%length of time

thetahat = zeros(M,N);
xhat = zeros(N,1);
Y = zeros(M,N);
c = 1e-6;

% Loop


for n=1:1:N

	% Generate Y. Set elements of Y that does not exist to zero
    if n>delay
       Y(2:M,n+1) = Y(1:M-1,n);
       Y(1,n+1) = y(n-delay);
    end
	% Estimate of x
    xhat (n) = thetahat(: , n)'  * Y( : , n);
	% Update the n+1 row in the matrix thetahat which in the notation in the Lecture Notes
	% corresponds to thetahat(n)
    muu_n = muu/(c+ sum(Y(:,n).^2));
    if n<N
    thetahat(: , n+1) = thetahat(: , n)+muu_n* Y( : , n) * (y(n+1)-xhat(n)); 
    end
end
%xhat shift to up by 1 and pad 0 at the end
xhat = [0;xhat(1:N-1)];
end
 
