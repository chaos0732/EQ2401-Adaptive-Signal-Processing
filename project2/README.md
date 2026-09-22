# Adaptive Signal Processing Project 2
## Task
This is the repository for KTH course EQ2401 Adaptive Signal Processing project 2. Details of the task is in file EQ2401Project2_2025.pdf  
Basically the task is to implement LMS, NLMS and RLS filters to denoise a piece of audio(EQ2401Project2data2025.wav).
## Ideas
To do the task first we should investigate feature of the signal(noise). It's no harm to plot the spectrogram of the signal, although it might not help. By doing so we find that there's low-frequency tonal noise.
![图片alt](/project2/pics/spectrogram.png "spectrogram of the signal")
### Intuitive idea 
An intuitive idea is to apply a High-pass filter since the noise is low-pass.
### Adaptive filter
To apply adaptive filters, the problem is that we can't find proper reference signal, and this is where Adaptive Line Enhancer(ALE) comes. The idea is to use delayed noisy signal as the reference, since the noise is tonal and remains high correlation but the speech signal is uncorrelated after delay. (see project2.pptx for the specific expression)

## File description
main.m: the main code to run  
HPF.m, LMS.m, NLMS.m, RLS.m: the 4 filters used for the project, packaged as functions  
.wav: data  
EQ2401Project2_2025.pdf: Task description  
project2.pptx: slides used to present  
pics: pictures used in this README.md file