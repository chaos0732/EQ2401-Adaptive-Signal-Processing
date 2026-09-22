function z_hp = HPF(z,fs)
    fc=1000;%cut-off frequency
    N=256;
    h=fir1(N-1,fc/(fs/2),'high');
    z_hp=filter(h,1,z);

    % Plot frequency response of the filter and spectrogram of filtered signal in one figure
    figure;
    % Frequency response of the filter
    [h,w] = freqz(h,1,512,fs);
    plot(w,abs(h));
    title('Frequency response of the HP filter');
    xlabel('Frequency/Hz');
    ylabel('Amplitude');

end