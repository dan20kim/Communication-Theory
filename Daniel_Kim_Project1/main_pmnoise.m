%% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:1*44100); % take first 5 seconds so compuation is not too long
%% Variables
Ac = 1;
Fc = 1e+6;
Fs = 44100;
L = ceil(3*Fc/Fs);
Fs2 = Fs*L;
N = length(x);
Nq = N*ceil(3*Fc/Fs);
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*ceil(3*Fc/Fs));
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs*ceil(3*Fc/Fs))/(2*pi);
k = 2;
%% Mod
x_pm_mod = PM_mod(x,Ac,Fc,Fs,k);


var = [.1,.25,.5];

x_pm_demod_noiseless = PM_demod(x_pm_mod,Fc,Fs,k);
x_pm_demod_noiseless = filter_noise(x_pm_demod_noiseless,Fs);

figure;
z = 1;
for i = var
    noise = sqrt(i)*randn(1,length(x_pm_mod));
    x_pm_mod_noisy = x_pm_mod + noise;
    x_pm_demod_noisy = PM_demod(x_pm_mod_noisy,Fc,Fs,k);
    x_pm_demod_noisy = filter_noise(x_pm_demod_noisy,Fs);
    
    Ps = powerdB(x_pm_demod_noiseless);
    Pn = powerdB(x_pm_demod_noisy - x_pm_demod_noiseless);
    SNR = Ps-Pn;
    disp("PM SNR with variance = " + i + " is: " + SNR);
    
    No = 2*i;
    W = 3000/Fs2;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10(((k^2)*(Ac^2)*Pm)/(2*No*W));
    disp("Theoretical PM SNR with variance = " + i + " is: " + theoretical_SNR);
   
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_pm_mod_noisy))));
    title("FFT of PM Modulated Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_pm_demod_noisy))));
    title("FFT of PM Output Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    z = z+2;
end

a = [1,2,4];
figure;
z = 1;
for k = a
    x_pm_mod = PM_mod(x,Ac,Fc,Fs,k);
    x_pm_demod_noiseless = PM_demod(x_pm_mod,Fc,Fs,k);
    x_pm_demod_noiseless = filter_noise(x_pm_demod_noiseless,Fs);
    
    noise = sqrt(.25)*randn(1,length(x_pm_mod));
    x_pm_mod_noisy = x_pm_mod + noise;
    x_pm_demod_noisy = PM_demod(x_pm_mod_noisy,Fc,Fs,k);
    x_pm_demod_noisy = filter_noise(x_pm_demod_noisy,Fs);
    
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_pm_mod_noisy))));
    title("FFT of PM Modulated Signal with AWGN var = .25 (k = " + k + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_pm_demod_noisy))));
    title("FFT of PM Output Signal with AWGN var = .25 (k = " + k + ")");
    xlabel('Frequency (Hz)');
    
    Ps = powerdB(x_pm_demod_noiseless);
    Pn = powerdB(x_pm_demod_noisy - x_pm_demod_noiseless);
    SNR = Ps-Pn;
    disp("PM SNR with variance = .25 (k = " + k + ") is: " + SNR);
    
    No = 2*i;
    W = 3000/Fs2;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10(((k^2)*(Ac^2)*Pm)/(2*No*W));
    disp("Theoretical PM SNR with variance = .25 (k = " + k + ") is: " + theoretical_SNR);
    z = z+2;
end
