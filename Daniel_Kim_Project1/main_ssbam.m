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
Fc = 550000;
Fs = 44100;
N = length(x);
Nq = N*ceil(3*Fc/Fs);
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*ceil(3*Fc/Fs));
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs*ceil(3*Fc/Fs))/(2*pi);
Fs2 = (Fs*ceil(3*Fc/Fs));
Ac = sqrt(2)/2;

%% Mod and demod
x_ssbam_mod = ssb_AM_mod(x,Fc,Fs,Ac);
x_ssbam_demod = ssb_AM_demod(x_ssbam_mod,Fc,Fs);

%% Plotting
figure;
subplot(2,1,1);
plot(tq,x_ssbam_mod)
title('SSB AM Modulated Signal');
xlabel('Time (s)'); 
subplot(2,1,2);
semilogy(fq,abs(fftshift(fft(x_ssbam_mod))));
title('FFT of SSB Modulated Signal');
xlabel('Frequency (Hz)');
figure;
plot(x_ssbam_demod);
title('SSB AM Demodulated Signal');
xlabel('Time (s)');
soundsc(x_ssbam_demod,44100);
%soundsc(x_cam_demod,44100);
a = rms(x)^2
b = rms(x_ssbam_demod)^2