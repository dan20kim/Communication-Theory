%% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:5*44100); % take first 5 seconds so compuation is not too long
max = max(abs(x));
x = x/max;
a = 1;
%% Variables
Fc = 550000;
Fs = 44100;
Ac = 1;
N = length(x);
L = ceil(3*Fc/Fs);
Nq = N*L;
Fs2 = Fs*L;
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, Nq);
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs2)/(2*pi);
%% Mod and demod
x_cam_mod = c_AM_mod(Ac, x, a, Fc,Fs);
x_cam_demod = c_AM_demod(Ac, x_cam_mod, a, Fc,Fs, 1/(2*pi*4000));
%% Plotting
figure;
plot(x);
title('Input Signal');
xlabel('Time (s)');
figure;
subplot(2,1,1);
plot(tq,x_cam_mod)
title('Conventional AM Modulated Signal');
xlabel('Time (s)');
subplot(2,1,2);
semilogy(fq,abs(fftshift(fft(x_cam_mod))))
title('FFT of Conventional AM Modulated Signal');
xlabel('Frequency (Hz)');
figure;
plot(x_cam_demod);
title('Conventional AM Demodulated Signal');
xlabel('Time (s)');
figure;
plot(f,abs(fftshift(fft(x))))
title('FFT of Input Signal');
xlabel('Frequency (Hz)');
soundsc(x,44100);
%soundsc(x_cam_demod,44100);
output_power= rms(x_cam_demod)^2
transmitted_power = rms(x_cam_mod)^2
input_power = rms(x)^2