clear;
%audio reading
[y,fs] = audioread('EQ2401project1data2025.wav');
%get noise samples. from the spectrogram we can find that the last 0.4s are noise.
noise = y(length(y)-(3000-1):length(y));  
%distribution fitting
noise_stats = fitdist(noise,'Normal');
sigma_noise = noise_stats.sigma;



%audio plot
figure;
subplot(1,2,1);%signal plot
plot(y);
title('Audio');

subplot(1,2,2);%spectro of the signal
spectrogram(y, hamming(256), 250, 256, fs, 'yaxis');
title('spectrogram');

figure;
subplot(1,3,1);%histogram of the noise and fitted distribution.
histogram(noise, 'Normalization', 'pdf');
hold on;
title('distribution of the noise');
%plot fitted distribution
x_values = linspace(min(noise), max(noise), 100);
y_values = pdf('Normal', x_values, noise_stats.mu, noise_stats.sigma);
plot(x_values, y_values, 'r-', 'LineWidth', 2);
legend('histogram of noise','fitted normal distribution')
hold off;

%autocorrelation 
subplot(1,3,2);
[r_nn, lags] = xcorr(noise,200,'biased');
stem(lags,r_nn);
title('Autocorrelation of noise:|r|');

% noise psd plotting
subplot(1,3,3);
[pxx, f] = pwelch(noise, hamming(512), 256, 1024, fs);
plot(f, 10*log10(pxx));
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of Noise');
grid on;

%% FIR wiener filter





%FIR wiener filter
N = 20;%order of filter, take y(n),y(n-1)....y(n-N+1) into account;
r_y_FIR = xcorr(y,N,'biased'); r_y_FIR = r_y_FIR(N+1:2*N);%calculate r_y(0),r_y(1),r_y(2)...
r_n_FIR = xcorr(noise,N,'biased'); r_n_FIR = r_n_FIR(N+1:2*N);
R_yy_FIR = toeplitz(r_y_FIR);
R_yx_FIR = r_y_FIR -  r_n_FIR;
h_FIR = R_yy_FIR\R_yx_FIR;
xhat_FIR = filter(h_FIR,1,y);

% %commented part is a try to window and filter
% win_size = 1024;
% for i = 1:win_size:length(y)-1
%     y_temp = y(i:min(i+win_size-1,length(y)));
%     r_y = xcorr(y_temp,N,"unbiased"); r_y = r_y(N+1:2*N);
%     r_n = xcorr(noise,N,"unbiased"); r_n = r_n(N+1:2*N);
%     R_yy = toeplitz(r_y);
%     R_yx = r_y -  r_n;
%     theta_opt_FIR = R_yx\R_yy;
%     xhat_FIR_windowed(i:min(i+win_size-1,length(y))) = conv(y_temp,theta_opt_FIR,'same');
% end

% soundsc(y,fs);
 %soundsc(xhat_FIR,fs);



%% non-Causal wiener filter


%  %non-Causal wiener filter
%  noise_padded = padarray(noise,length(y)-length(noise),"circular","post");
% r_n_nonCausal = xcorr(noise_padded,"biased");%auto correlation of noise
% %r_n_nonCausal = r_n_nonCausal(length(y):end);
% r_y_nonCausal = xcorr(y,"biased");%auto correlation of y,
% %r_y_nonCausal = r_y_nonCausal(length(y):end);
% phi_y_nonCausal = fft(r_y_nonCausal,length(y));
% phi_xy_nonCausal = fft((r_y_nonCausal-r_n_nonCausal),length(y));%
% H_nonCausal = phi_xy_nonCausal./phi_y_nonCausal;
% H_nonCausal(H_nonCausal<0)=0;
% h_nonCausal = ifft(H_nonCausal);
% y_FFT = fft(y);
% xhat_nonCausal = real(ifft(y_FFT.*H_nonCausal));
% figure;
% plot(y);
% hold on;
% title("H");
% plot(xhat_nonCausal);

[xhat_nonCausal, H_nonCausal] = wienerFilterNonCausal_corr(y, noise);


%% causal wiener filter

% win_size = 256;
% for i = 1:win_size:length(y)-1
%     y_temp = y(i:min(i+win_size-1,length(y)));
%     [xhat_nonCausal_windowed, H_nonCausal_windowed] = wienerFilterNonCausal_corr(y_temp, noise(1:win_size));
%     xhat_nonCausal(i:min(i+win_size-1,length(y))) =xhat_nonCausal_windowed;
% end
% figure;
% subplot(3,1,1);
% plot(y);
% subplot(3,1,3);
% plot(xhat_nonCausal_windowed);
% subplot(3,1,2);
% plot(xhat_nonCausal);
% soundsc(xhat_nonCausal,fs)




% %causal wiener filter
% win_size = 256;
% for i = 1:win_size:length(y)
%     y_temp = y(i:min(i+win_size-1,length(y)));
%     noise_temp = noise(1:length(y_temp));
%     r_y_Causal = xcorr(y_temp,"biased");%auto correlation of y,
%     r_n_Causal = xcorr(noise_temp,"biased");
%     phi_xy_z = r_y_Causal-r_n_Causal;   %F(z) = sum f(n)z^{-n}, phi_xy = phi_yy-phi_nn;
%     phi_y_z = r_y_Causal;
% 
% 
%     zeros = roots(phi_y_z);
%     zeros_causal = zeros(abs(zeros)<1);
%     zeros_noncausal = zeros(abs(zeros)>=1); 
%     phi_y_z_causal = poly(zeros_causal)';
%     phi_y_z_noncausal = poly(zeros_noncausal)'.*phi_y_z(1);
%     phi_y_z_reconstruct = conv(phi_y_z_causal, phi_y_z_noncausal);
%     test = phi_y_z_reconstruct./phi_y_z;
% 
%     [q,r] = deconv(phi_xy_z,phi_y_z_noncausal);
%     phi_y_causal_fft = fft(phi_y_z_causal);
%     H_Causal = fft(q)./fft(phi_y_z_causal);
%     y_temp_FFT = fft(y_temp);
%     xhat_Causal (i:min(i+win_size-1,length(y))) = real(ifft(H_Causal.*y_temp_FFT));
%     h_Causal = ifft(H_Causal);
% end
[xhat_Causal, H_Causal] = causalWienerFilter(y, noise);

%% Plot of results
%audio
figure;
subplot(3,1,1);
plot(y);
hold on;
plot(xhat_FIR);
hold off;
title("FIR Wiener Filter")
legend('y','xhat');

subplot(3,1,2);
hold on;
plot(y);
plot(xhat_nonCausal);
hold off;
title("nonCausal Wiener Filter");
legend('y','xhat');

subplot(3,1,3);
hold on;
plot(y);
plot(xhat_Causal);
hold off;
title("Causal Wiener Filter");
legend('y','xhat');


%frequency response plot
figure;
nfft = 128;
subplot(1,3,1);
[H_FIR, w] = freqz(h_FIR, 1, nfft, 8000);
plot(w,20*log10(abs(H_FIR)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title("FIR");

subplot(1,3,2);
N_old = length(H_nonCausal)/2; N_new = nfft;
f_old = linspace(0,fs/2,N_old);
H_nonCausal_sampled = interp1(f_old,abs(H_nonCausal(1:N_old,1)),w,'spline');
plot(w,20*log10(H_nonCausal_sampled+1e-12));%avoid zero
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title("nonCausal");

subplot(1,3,3);
N_old = length(H_Causal)/2; N_new = nfft;
f_old = linspace(0,fs/2,N_old);
H_Causal_sampled = interp1(f_old,abs(H_Causal(1:N_old,1)),w,'spline');
plot(w,20*log10(H_Causal_sampled+1e-12));%avoid zero
%plot(20*log10(H_nonCausal(1:N_old,1)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title("Causal");

%spectrum of xhat
figure;
hold on;
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of x_hat');
grid on;
window = hamming(512); overlap = 256; nfft = 1024;
[phi_y, f] = pwelch(y,window, overlap, nfft, fs);
plot(f, 10*log10(phi_y),LineWidth=1);
[phi_FIR, f] = pwelch(xhat_FIR, window, overlap, nfft, fs);
plot(f, 10*log10(phi_FIR));
[phi_nonCausal, f] = pwelch(xhat_nonCausal, window, overlap, nfft, fs);
plot(f, 10*log10(phi_nonCausal));
[phi_Causal, f] = pwelch(xhat_Causal, window, overlap, nfft, fs);
plot(f, 10*log10(phi_Causal));
hold off;
legend("y","FIR","nonCausal","Causal")
