%% Clear Stage
clear; close all; clc;
%% Audio Input
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:1*44100); % take first 5 seconds so compuation is not too long
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

%% Mod
x_cam_mod = c_AM_mod(Ac, x, a, Fc,Fs);


var = [.1,.25,.5];

x_cam_demod_noiseless = c_AM_demod(Ac, x_cam_mod, a, Fc,Fs, 1/(2*pi*4000));
x_cam_demod_noiseless = filter_noise(x_cam_demod_noiseless,Fs);

figure;
subplot(2,1,1);
semilogy(f,abs(fftshift(fft(x))));
title('FFT of Input Signal');
xlabel('Frequency (Hz)');
subplot(2,1,2);
semilogy(fq,abs(fftshift(fft(x_cam_mod))));
title('FFT of Noise Free Modulated Signal');
xlabel('Frequency (Hz)');
figure;
z = 1;
for i = var
    noise = sqrt(i)*randn(1,length(x_cam_mod));
    x_cam_mod_noisy = x_cam_mod + noise;
    x_cam_demod_noisy = c_AM_demod(Ac, x_cam_mod_noisy, a, Fc,Fs, 1/(2*pi*4000));
    x_cam_demod_noisy = filter_noise(x_cam_demod_noisy,Fs);
    
    Ps = powerdB(x_cam_demod_noiseless);
    Pn = powerdB(x_cam_demod_noisy - x_cam_demod_noiseless);
    SNR = Ps-Pn;
    disp("Conventional AM SNR with variance = " + i + " is: " + SNR);
    
    Pn_theor = 4*(2*4000/Fs2)*i;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10(a^2*(Ac^2)*Pm/(Pn_theor));
    disp("Theoretical Conventional AM SNR with variance = " + i + " is: " + theoretical_SNR);
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_cam_mod_noisy))));
    title("FFT of Conventional AM Modulated Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_cam_demod_noisy))));
    title("FFT of Conventional AM Output Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    z = z+2;
end

disp("----------------")
a = [.5,1,2];

figure;
z = 1;
for j = a
    x_cam_mod = c_AM_mod(Ac, x, j, Fc,Fs);
    x_cam_demod_noiseless = c_AM_demod(Ac, x_cam_mod, j, Fc,Fs, 1/(2*pi*4000));
    x_cam_demod_noiseless = filter_noise(x_cam_demod_noiseless,Fs);
    
    noise = sqrt(.25)*randn(1,length(x_cam_mod));
    x_cam_mod_noisy = x_cam_mod + noise;
    x_cam_demod_noisy = c_AM_demod(Ac, x_cam_mod_noisy, a, Fc,Fs, 1/(2*pi*4000));
    x_cam_demod_noisy = filter_noise(x_cam_demod_noisy,Fs);
    
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_cam_mod_noisy))));
    title("FFT of Conventional AM Modulated Signal with AWGN var = .25 (a = " + j + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_cam_demod_noisy))));
    title("FFT of Conventional AM Output Signal with AWGN var = .25 (a = " + j + ")");
    xlabel('Frequency (Hz)');
    
    Ps = powerdB(x_cam_demod_noiseless);
    Pn = powerdB(x_cam_demod_noisy - x_cam_demod_noiseless);
    SNR = Ps-Pn;
    disp("Conventional AM SNR with variance = .25 (a = " + j + ") is: " + SNR);
    
    Pn_theor = 4*(2*4000/Fs2)*.25;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10((j^2)*(Ac^2)*Pm/(Pn_theor));
    disp("Theoretical Conventional AM SNR with variance = .25 (a = " + j + ") is: " + theoretical_SNR);
    z = z+2;
end
%soundsc(x,44100);
%soundsc(x_cam_demod_noiseless,44100);