 %% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:44100); % take first 5 seconds so compuation is not too long
max = max(abs(x));
x = x/max;
%% Variables
Fc = 1e+6;
Fs = 44100;
N = length(x);
L = ceil(15*Fc/Fs);
Nq = N*L;
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*L);
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs*L)/(2*pi);
Fs2 = (Fs*L);
Ac = 1;
%% Mod and demod
x_fmmod = FM_mod(x,Ac,Fc,Fs,75000);
x_fmdemod = FM_demod(x_fmmod,Fc,Fs,75000);
%% Plotting
figure;
plot(x);
title('Input Signal');
xlabel('Time (s)');
figure;
subplot(2,1,1);
plot(tq,x_fmmod)
title('FM Modulated Signal');
xlabel('Time (s)');
subplot(2,1,2);
semilogy(fq,abs(fftshift(fft(x_fmmod)/Fs2)));
title('FFT of FM Modulated Signal');
xlabel('Frequency (Hz)');
figure;
plot(x_fmdemod);
title('FM Demodulated Signal');
xlabel('Time (s)');
soundsc(x_fmdemod,44100);
figure;
plot(fq,abs(fftshift(fft(x_fmmod)/Fs2)));
title('FFT of FM Modulated Signal');
xlabel('Frequency (Hz)');

pRMS = rms(x_fmdemod)^2
p = rms(x)^2