%% Clear Stage
clear; close all; clc;
%% 
[y,fs] = audioread('bananas.mp3');
info = audioinfo('bananas.mp3');
x = y(:,1)'; % take one channel of audio
x = x(1:1*44100); % take first 5 seconds so compuation is not too long
max = max(abs(x));
x = x/max;
%% Variables
Fc = 550000;
Fs = 44100;
Ac = sqrt(2)/2;
N = length(x);
L = ceil(3*Fc/Fs);
Nq = N*L;
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*ceil(3*Fc/Fs));
wd = linspace(-pi,pi,N);
wdq = linspace(-pi,pi,Nq);
f = wd*Fs/(2*pi);
fq = wdq*(Fs*ceil(3*Fc/Fs))/(2*pi);
Fs2 = (Fs*ceil(3*Fc/Fs));
%% Mod
x_ssb_mod = ssb_AM_mod(x, Fc, Fs, Ac);

var = [.1,.25,.5];

x_ssb_demod_noiseless = ssb_AM_demod(x_ssb_mod, Fc,Fs);
x_ssb_demod_noiseless = filter_noise(x_ssb_demod_noiseless,Fs);

figure;
z = 1;
for i = var
    noise = sqrt(i)*randn(1,length(x_ssb_mod));
    x_ssb_mod_noisy = x_ssb_mod + noise;
    x_ssb_demod_noisy = ssb_AM_demod(x_ssb_mod_noisy, Fc,Fs);
    x_ssb_demod_noisy = filter_noise(x_ssb_demod_noisy,Fs);
    Ps = powerdB(x_ssb_demod_noiseless);
    Pn = powerdB(x_ssb_demod_noisy - x_ssb_demod_noiseless);
    SNR = Ps-Pn;
    disp("SSB SNR with variance = " + i + " is: " + SNR);
    
    Pn_theoretical = 2*(2*4000/Fs2)*i;
    Pm = rms(x)^2;
    theoretical_SNR = 10*log10((Ac^2)*Pm/(Pn_theoretical));
    disp("Theoretical SSB SNR with variance = " + i + " is: " + theoretical_SNR);
    
    subplot(3,2,z);
    semilogy(fq,abs(fftshift(fft(x_ssb_mod_noisy))));
    title("FFT of SSB Modulated Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    subplot(3,2,z+1);
    semilogy(f,abs(fftshift(fft(x_ssb_demod_noisy))));
    title("FFT of SSB Output Signal with AWGN (var = " + i + ")");
    xlabel('Frequency (Hz)');
    z = z+2;
end

soundsc(x_ssb_demod_noisy,44100);