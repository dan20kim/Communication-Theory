%% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:1*44100); % take first 1 second so compuation is not too long
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
k = 300;
Ac = 100;
%% Mod
x_fm_mod = FM_mod(x,Ac, Fc,Fs,k);


var = [.1,.25,.5];

x_fm_demod_noiseless = FM_demod(x_fm_mod,Fc,Fs,k);
x_fm_demod_noiseless = filter_noise(x_fm_demod_noiseless,Fs);

figure;
z =1
for i = var
    noise = sqrt(i)*randn(1,length(x_fm_mod));
    x_fm_mod_noisy = x_fm_mod + noise;
    x_fm_demod_noisy = FM_demod(x_fm_mod_noisy,Fc,Fs,k);
    x_fm_demod_noisy = filter_noise(x_fm_demod_noisy,Fs);
    
    Ps = powerdB(x_fm_demod_noiseless);
    Pn = powerdB(x_fm_demod_noisy - x_fm_demod_noiseless);
    SNR = Ps-Pn;
    disp("FM SNR with variance = " + i + " is: " + SNR);
    
    No = 2*i;
    W = 1000/Fs2;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10((3*(k^2)*(Ac^2)*Pm)/(2*No*(1000^2)*W));
    disp("FM Theoretical SNR with variance = " + i + " is: " + theoretical_SNR);
    
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_fm_mod_noisy))));
    title("FFT of FM Modulated Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1.);
    semilogy(f,abs(fftshift(fft(x_fm_demod_noisy))));
    title("FFT of FM Output Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    z = z+2;
end

a = [150,300,600];
z = 1;
figure;
for k = a
    x_fm_mod = FM_mod(x,Ac, Fc,Fs,k);
    x_fm_demod_noiseless = FM_demod(x_fm_mod,Fc,Fs,k);
    x_fm_demod_noiseless = filter_noise(x_fm_demod_noiseless,Fs);
    
    noise = sqrt(.25)*randn(1,length(x_fm_mod));
    x_fm_mod_noisy = x_fm_mod + noise;
    x_fm_demod_noisy = FM_demod(x_fm_mod_noisy,Fc,Fs,k);
    x_fm_demod_noisy = filter_noise(x_fm_demod_noisy,Fs);
    
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_fm_mod_noisy))));
    title("FFT of FM Modulated Signal with AWGN var = .25 (k = " + k + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_fm_demod_noisy))));
    title("FFT of FM Output Signal with AWGN var = .25 (k = " + k + ")");
    xlabel('Frequency (Hz)');
    
    
    Ps = powerdB(x_fm_demod_noiseless);
    Pn = powerdB(x_fm_demod_noisy - x_fm_demod_noiseless);
    SNR = Ps-Pn;
    disp("FM SNR with variance = .25 (k = " + k + ") is: " + SNR);
    
    No = 2*i;
    W = 1000/Fs2;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10((3*(k^2)*(Ac^2)*Pm)/(2*No*(1000^2)*W));
    disp("FM Theoretical SNR with variance = .25 (k = " + k + ") is: " + theoretical_SNR);
    z = z+2;
end