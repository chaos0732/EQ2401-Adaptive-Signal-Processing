function [x_hat, H_freq] = causalWienerFilter(y, noise)
% H(z) = 1/ Phi_y^+(z) * { z^m * Phi_xy(z)/Phi_y^-(z) }_+
%   y: signal with noise
%   noise : noise samples
%  m =0 for filter


    N = length(y);

    % calculate ACF
    r_y = xcorr(y,(N-1)/2, 'biased');          
    r_n = xcorr(noise,(N-1)/2, 'biased');      
    r_xy = r_y - r_n;                  


    S_y  = abs(fft(r_y));
    
    S_n = abs(fft(r_n));
    S_xy = S_y-S_n; S_xy(S_xy<0)=0;
    % figure
    % plot(10*log10(abs(S_y)));
    % title("Sy");
    % hold on;
    % plot(10*log10(abs(S_n)));
    

    % spectrum factorization
    [Phi_y_plus, Phi_y_minus] = spectralFactorPlusMinus(S_y);


    ratio_freq = (S_xy ./ Phi_y_minus);

    c_long = ifft(ratio_freq); 
    mid = (N-1)/2+1;
    c_causal = zeros(N,1);
    c_causal(mid:end) = c_long(mid:end); % n>=0 causal part
    C_causal_freq = fft(c_causal);

    H_freq = C_causal_freq ./Phi_y_plus;
    % figure;
    % plot(10*log10(abs(H_freq)));
    % title("H causal");
    
    %calculate impulse response h
    h_long = ifft(H_freq);
    h_causal = h_long(mid:end);  


    % figure;
    % hold on;
    % plot(h_long);
    % plot(h_causal);
    % hold off;

    %filtering
    y_fft = fft(y);
    X_hat = y_fft.*H_freq;
    x_hat = ifft(X_hat,'symmetric');
end

