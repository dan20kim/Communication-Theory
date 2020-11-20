%% ECE300: Communication Theory HW 2
%%
% Initialization of variables

% Author: Daniel Kim
% Professor: Brian L. Frost
% 9/8/20
clear; close all; clc;
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
m = y(:,1)'; % take one channel of audio
sound(m,fs);
N = length(m);
T = N/fs;
fsq = 40*fs; % q subscript for upsampled variables
t = linspace(0,T,N);
tq = linspace(0,T,N*40);
m = m./max(abs(m)); % makes the max value of m 1
figure;
plot(t,m);
xlabel('Time(s)');
title('m(t)');

%% Question 1
% take fft, and create wd and f
M = fft(m);
Ms = (fftshift(M)/fs);
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,N*40); % upsampled wd vector
f = wd*fs/(2*pi);
fq = wdq*fsq/(2*pi); % upsampled frequency vector

% Plotting
figure;
subplot(3,1,1);
semilogy(f,abs(Ms));
ylabel('|M(f)|');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of M(f)');
subplot(3,1,2);
plot(f,abs(Ms));
ylabel('|M(f)|');
xlabel('Frequency(Hz)');
title('Magnitude of M(f)');
subplot(3,1,3);
plot(f,unwrap(angle(Ms)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of M(f)');

%%
% The bandwidth of the signal is ~4kHz. This was obtained by looking at the
% positive support of the signal in the frequency domain
%% Question 2
fc = 550000; % carrier frequency
c = cos(2*pi*fc*tq);
s = sin(2*pi*fc*tq);
mq = interp1(t,m,tq,'linear','extrap'); % linear interpolated m(t)

%% Question 3
% DSC-SC:
u_dsbsc = mq.*c;

% Take fft
U_dsbsc = fft(u_dsbsc);
U_dsbsc_s = (fftshift(U_dsbsc)/fsq);

% Plotting
figure;
subplot(2,2,[1,2]);
plot(tq,u_dsbsc);
xlabel('Time(s)');
title('u_{dsbsc}(t)');
subplot(2,2,3);
semilogy(fq,abs(U_dsbsc_s));
ylabel('log(|U_{dsbsc}|)');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of U_{dsbsc}(f)');
subplot(2,2,4);
plot(fq,unwrap(angle(U_dsbsc_s)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{dsbsc}(f)');
%%
% DSB-AM:
u_dsb = u_dsbsc + c;

% Take fft
U_dsb = fft(u_dsb);
U_dsb_s = fftshift((U_dsb)/fsq);

% Plotting
figure;
subplot(2,2,[1,2]);
plot(tq,u_dsb);
xlabel('Time(s)');
title('u_{dsb}(t)');
subplot(2,2,3);
semilogy(fq,abs(U_dsb_s));
ylabel('log(|U_{dsb}|)');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of U_{dsb}(f)');
subplot(2,2,4);
plot(fq,unwrap(angle(U_dsb_s)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{dsb}(f)');

%%
% The only notable difference between the DSB AM and DSB SC in the 
% frequency domain is that the peak at ~550 kHz on the DSB AM is
% significantly higher than the peak at ~550 kHz on the DBS SC.
%% Question 4
% Upper and Lower SSB AM
u_ussb = mq.*c - HilbertTransform(mq,fq).*s;
u_lssb = mq.*c + HilbertTransform(mq,fq).*s;

% take fft
U_ussb = fft(u_ussb);
U_ussbs = (fftshift(U_ussb)/fs);
U_lssb = fft(u_lssb);
U_lssbs = (fftshift(U_lssb)/fs);

% Plotting
figure;
subplot(3,2,1);
plot(tq,u_ussb);
xlabel('Time(s)');
title('u_{ussb}(t)');
subplot(3,2,2);
plot(tq,u_lssb);
xlabel('Time(s)');
title('u_{lssb}(t)');
subplot(3,2,3);
semilogy(fq,abs(U_ussbs));
ylabel('log(|U_{ussb}|)');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of U_{ussb}(f)');
subplot(3,2,4);
semilogy(fq,abs(U_lssbs));
ylabel('log(|U_z{lssb}|)');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of U_{lssb}(f)');
subplot(3,2,5);
plot(fq,unwrap(angle(U_ussbs)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{ussb}(f)');
subplot(3,2,6);
plot(fq,unwrap(angle(U_lssbs)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{lssb}(f)');

%% Question 5
% Conventional AM
u_conventional = (1+mq).*c;

% Take fft
U_conventional = fft(u_conventional);
U_conventional_s = (fftshift(U_conventional)/fsq);

% Plotting
figure;
subplot(2,2,[1,2]);
plot(tq,u_conventional);
xlabel('Time(s)');
title('u_{conventional}(t)');
subplot(2,2,3);
semilogy(fq,abs(U_conventional_s)); 
ylabel('log(|U_{conventional}|)');
xlabel('Frequency(Hz)');
title('Semi-log Magnitude of U_{conventional}(f)');
subplot(2,2,4);
plot(fq,unwrap(angle(U_conventional_s)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{conventional}(f)');
%% Question 6
% Demodulation

% Rectification
u_conventional(u_conventional < 0) = 0;

% Take fft and plot
U_conventional = fft(u_conventional);
U_conventional_s = (fftshift(U_conventional)/fsq);

% Plotting
figure;
subplot(2,2,[1,2]);
plot(tq,u_conventional);
xlabel('Time(s)');
title('u_{conventional}(t) Rectified');
subplot(2,2,3);
semilogy(fq,abs(U_conventional_s));
ylabel('log(|U_{conventional}|)');
xlabel('Frequency (Hz)');
title('Semi-log Magnitude of U_{conventional}(f) Rectified');
subplot(2,2,4);
plot(fq,unwrap(angle(U_conventional_s)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{conventional}(f) Rectified');

% Filtering: cutoff of 3kHz gave good sound quality
filter = 2*pi*3000./(abs(fq) + 2*pi*3000); % first order low pass filter
U_filtered = U_conventional_s.*filter; % multiplication in frequency domain
u_filtered = ifft(fftshift(U_filtered)*fsq); % convert back to time domain

% Plotting
figure; 
subplot(2,2,[1,2]);
plot(tq,abs(u_filtered)); 
xlabel('Time(s)');
title('u_{filtered}(t)');
subplot(2,2,3);
semilogy(fq,abs(U_filtered));
ylabel('log(|U_{filtered}|)');
xlabel('Frequency (Hz)');
title('Semi-log Magnitude of U_{filtered}(f)');
subplot(2,2,4);
plot(fq,unwrap(angle(U_filtered)));
ylabel('Radians');
xlabel('Frequency(Hz)');
title('Phase of U_{filtered}(f)');

% downsampling and play sound  
u_filtered_downsampled = decimate(u_filtered,40);   
%sound(real(u_filtered_downsampled),fs);