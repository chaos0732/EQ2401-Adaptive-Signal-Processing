%%  S(ω) => S^+(ω) & S^-(ω)
function [Splus, Sminus] = spectralFactorPlusMinus(S_omega)

    L = length(S_omega);
    S_omega = max(S_omega,1e-12);

    logS = log(S_omega);
    s_time = ifft(logS);
    %g = fftshift(g);
    mid = floor(L/2)+1;

    % causal part->s_pos, non causal part->s-neg
    s_pos = zeros(L,1);
    s_neg = zeros(L,1);
    s_pos(mid:end) = s_time(mid:end);
    s_neg(1:mid-1) = s_time(1:mid-1);

    Splus_freq  = fft(s_pos);
    Sminus_freq = fft(s_neg);
    Splus  = exp(Splus_freq);
    Sminus = exp(Sminus_freq);
    % figure;
    % plot(ifft(Splus));
    % hold on;
    % plot(ifft(Sminus));
    % hold off;
    % legend("causal part","noncausal part");
end
