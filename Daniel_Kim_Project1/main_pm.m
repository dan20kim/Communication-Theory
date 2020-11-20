%% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:5*44100); % take first 5 seconds so compuation is not too long
max = max(abs(x));
x = x/max;
%% Variables
Ac = 1;
Fc = 1e+6;
Fs = 44100;
L = ceil(3*Fc/Fs);
N = length(x);
Nq = N*ceil(3*Fc/Fs);
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*ceil(3*Fc/Fs));
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs*ceil(3*Fc/Fs))/(2*pi);
Fs2 = Fs*L;
%% Mod and demod
x_pmmod = PM_mod(x,Ac,Fc,Fs,2);
x_pmdemod = PM_demod(x_pmmod,Fc,Fs,2);
%% Plotting
figure;
subplot(2,1,1);
plot(tq,x_pmmod)
title('PM Modulated Signal');
xlabel('Time (s)');
subplot(2,1,2);
semilogy(fq,abs(fftshift(fft(x_pmmod))));
title('FFT of PM Modulated Signal');
xlabel('Frequency (Hz)');
figure;
plot(x_pmdemod);
title('PM Demodulated Signal');
xlabel('Time (s)');
figure;
plot(fq,abs(fftshift(fft(x_pmmod)/Fs2)));
title('FFT of PM Modulated Signal');
xlabel('Frequency (Hz)');
soundsc(x_pmdemod,44100);