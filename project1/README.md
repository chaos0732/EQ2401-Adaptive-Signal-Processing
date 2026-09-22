# Adaptive Signal Processing Project 1

## Task
This is the repository for KTH course EQ2401 Adaptive Signal Processing project 1. Details of the task are in file EQ2410project1_2025.pdf  
The task is to denoise a piece of audio (EQ2401project1data2025.wav) with Wiener filters, and to compare the FIR, non-causal and causal versions.

## Ideas
### Getting the noise statistics
The filters all need the noise statistics, so the first step is to get a clean look at the noise itself. From the spectrogram the last 0.4 s of the recording turns out to be noise only, so those 3000 samples are taken as the noise record. Fitting a normal distribution to them, plus the autocorrelation and a Welch PSD estimate, gives everything the filters need.

![noise statistics](/project1/pics/NoiseStatistics.jpg "noise statistics")

From here `r_xy = r_y - r_n` and `S_xy = S_y - S_n` (clipped at zero), which is what lets us build every filter from the noisy signal alone.

### FIR Wiener filter
The straightforward one: take a filter of order N = 20, build the Toeplitz matrix from `r_y`, and solve the normal equations `R_yy h = R_yx`. Cheap and causal by construction.

### Non-causal Wiener filter
Done entirely in the frequency domain: `H = S_xy / S_y`, applied to the FFT of the signal. It gives the best result of the three, but it needs the whole signal in advance, so it is not realisable in real time.

### Causal Wiener filter
The interesting one. It needs the spectral factorization `S_y = Phi_y^+ · Phi_y^-`, done in `spectralFactorPlusMinus.m` by splitting the cepstrum (the inverse FFT of `log S`) into its causal and anti-causal halves and exponentiating each back. The filter is then

```
H(z) = 1 / Phi_y^+(z) · { S_xy(z) / Phi_y^-(z) }_+
```

which keeps causality while staying close to the non-causal optimum.

## Results
Time domain, all three against the noisy input:

![filtered audio](/project1/pics/filteredaudio.jpg "filtered audio")

Frequency responses:

![frequency response](/project1/pics/FrequencyResponse.jpg "frequency responses")

## File description
Project.m: the main code to run  
causalWienerFilter.m, wienerFilterNonCausal_corr.m: the two Wiener filters packaged as functions (the FIR one is short enough to sit inline in Project.m)  
spectralFactorPlusMinus.m: spectral factorization helper used by the causal filter  
.wav: data  
EQ2410project1_2025.pdf: Task description  
project1.pptx: slides used to present  
pics: pictures used in this README.md file
