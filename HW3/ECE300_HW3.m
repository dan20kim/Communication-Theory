%% ECE300: Communication Theory HW 3
%%
% Initialization of variables

% Author: Daniel Kim
% Professor: Brian L. Frost
% 9/25/20

%% Question 7
clear; close all; clc
w=linspace(-pi*1000,pi*1000,10001);
variance = 1000;
M = 1000;
m = linspace(-1000,1000,2001); 
noisevec = sqrt(variance)*randn(1,500000); % white noise 
[rx, psd] = AutoCorrelation(noisevec,M);

%%
% Plot
figure;
subplot(2,1,1);
stem(m,rx);
xlabel('m');
title('Autocorrelation of White Noise')
subplot(2,1,2);
semilogy(w,abs(psd));
ylim([1,3000]);
xlabel('w');
title('PSD of White Noise');

%%
% The autocorrelation of white noise looks like a delta and the PSD looks
% like a flat line.
%% Question 8  
%
Y = sqrt(variance)*randn(1,500000);
Z = sqrt(variance)*randn(1,500000);
t = linspace(0,10,500000);
X = Y.*cos(10000*t) + Z.*sin(10000*t);
[x_rx,x_psd] = AutoCorrelation(X,M);

%%
% Plot
figure;
semilogy(w,abs(x_psd));
ylim([.001,3000]);
title('PSD of x(t)');
xlabel('w');
x_psd_integral = x_psd./(w.*w);
figure;
semilogy(w,abs(x_psd_integral));
title('PSD of integral of x(t)');
xlabel('w');