 clear all;close all;
 [z,fs]=audioread('EQ2401Project2_bonus_task2025.wav');
 time = length(z)/fs;

%% input signal and spectrogram
% audio plot
figure;
subplot(1,2,1);%signal plot
plot(z);
title('Audio');

subplot(1,2,2);%spectro of the signal
spectrogram(z, hamming(256), 250, 500, fs, 'yaxis');
title('spectrogram');

%% compare the spectrum w/wo human voice
figure;
subplot(2,1,1);
windowsize=256;
frame1=z(1:windowsize);
frame1=frame1.*hamming(windowsize);
frame1_fft=fft(frame1);
frame1_fft=frame1_fft(1:windowsize/2+1);
frame1_fft=abs(frame1_fft);
f=fs*(0:(windowsize/2))/windowsize;
plot(f,frame1_fft);
title('Spectrum without human voice');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
frame2 = z(4000+1:4000+windowsize);
frame2 = frame2.*hamming(windowsize);
frame2_fft = fft(frame2);
frame2_fft = frame2_fft(1:windowsize/2+1);
frame2_fft = abs(frame2_fft);
plot(f,frame2_fft);
title('Spectrum with human voice');
xlabel('Frequency (Hz)');
ylabel('Magnitude');



%% first intuitive attempt: pass a high-pass filter
shat_HP = HPF(z,fs);
%plot
figure;
subplot(1,2,1);%signal plot
plot(shat_HP);
title('High pass');
subplot(1,2,2);%spectro of the signal
spectrogram(shat_HP, hamming(256), 250, 500, fs, 'yaxis');
title('spectrogram');
%sound(shat_HP,fs);


%% plot acf to determin d
[rz,lags] = xcorr(z,z,300,"normalized");
figure;
plot(lags,rz);
title('ACF of z')


%% use LMS method to estimate noise signal
%noise signal x = \theta^T * Y
%Y(n) is a vector of several sinusoidal functions
%From the spectrogram of signal z we find noise  is much larger than the
%desired signal

%parameters
M_LMS = 128;
muu_LMS = 0.01;
delay  = 35;
[thetahat_LMS,xhat_LMS]=LMS(z,M_LMS,muu_LMS,delay);
shat_LMS = z - xhat_LMS;


%plot
figure;
subplot(1,2,1);%signal plot
plot(shat_LMS);
title('LMS');
subplot(1,2,2);%spectro of the signal
spectrogram(shat_LMS, hamming(256), 250, 500, fs, 'yaxis');
title('spectrogram');


%pause to finish playing the audio
soundsc(shat_LMS,fs);
wait = 0.5;
pause(time + wait);

%% NLMS method

%parameters
M_NLMS = 128;
muu_NLMS = 0.5;

[thetahat_NLMS,xhat_NLMS]=NLMS(z,M_NLMS,muu_NLMS,delay);
shat_NLMS = z - xhat_NLMS;

%plot
figure;
subplot(1,2,1);%signal plot
plot(shat_NLMS);
title('NLMS');
subplot(1,2,2);%spectro of the signal
spectrogram(shat_NLMS, hamming(256), 250, 500, fs, 'yaxis');
title('spectrogram');

%pause to finish playing the audio
soundsc(shat_NLMS,fs);
pause(time + wait);

%%  RLS method

%parameters
M_RLS = 128;
lambda = 0.999;
[thetahat_RLS, xhat_RLS] = RLS(z,M_RLS,lambda,delay);
shat_RLS = z - xhat_RLS;

%plot
figure;
subplot(1,2,1);%signal plot
plot(shat_RLS);
title('RLS');
subplot(1,2,2);%spectro of the signal
spectrogram(shat_RLS, hamming(256), 250, 500, fs, 'yaxis');
title('spectrogram');


%pause to finish playing the audio
soundsc(shat_LMS,fs);
wait = 0.5;
pause(time + wait);

