function [x_hat, H] = wienerFilterNonCausal_corr ( y, noise)



    N  = length(y);
    Nn = length(noise);


    %calculate autocorrelation
     Y = fft(y);
    % N_fft = fft(noise_pad);
    r_y = xcorr(y,(N-1)/2,"biased");
    r_n = xcorr(noise,(N-1)/2,"biased");
    %r_n = padarray(r_n,(N-Nn)/2,0,"both");

    % estimate psd
    %    fft(ACF) 
    % Syy = (abs(Y).^2) / L;
    % Snn = (abs(N_fft).^2) / L; simple square not a good solution
    Syy = abs(fft(r_y));
    Snn = abs(fft(r_n));
    Sxy = Syy-Snn;Sxy(Sxy<0)=0;
    
    % %plotting for debug
    % figure;
    % subplot(1,2,1);
    % plot(10*log10(abs(Syy)));
    % subplot(1,2,2);
    % plot(10*log10(abs(Snn)));

    %calculate filter H
    H = abs(Sxy)./abs(Syy);

    %H should be >0, otherwise signal is covered by noise
    H (H<0) = 0;

    % %plotting for debug
    % figure;
    % plot(abs(H));

    %filter and ifft
    X_hat_freq = Y .* H;
    x_hat = ifft(X_hat_freq);  % take real part

end
