function [output] = c_AM_demod(Ac, input, a, Fc, Fs, tau)
N = length(input);
T = N/(Fs*ceil(3*Fc/Fs));
wd = linspace(-pi,pi,N);
f = wd*(Fs*ceil(3*Fc/Fs))/(2*pi);
t = linspace(0,T,N);


input(input<0) = 0;

% Take fft and plot
INPUT_conventional = fft(input);
INPUT_conventional_s = (fftshift(INPUT_conventional)/(Fs*ceil(3*Fc/Fs)));

% Filtering: cutoff of 3kHz gave good sound quality
filter = (1/tau)./((1j*2*pi*f) + 1/tau); % first order low pass filter
high_pass = ((1j*2*pi*f)*(1/(2*pi*20)))./(1+((1j*2*pi*f)*(1/(2*pi*20))));
INPUT_filtered = INPUT_conventional_s.*filter.*high_pass; % multiplication in frequency domain
input_filtered = ifft(fftshift(INPUT_filtered)*(Fs*ceil(3*Fc/Fs))); % convert back to time domain
%figure;
%plot(filter);

% downsampling and play sound  
output = sqrt(11.36)*real(decimate(input_filtered,ceil(3*Fc/Fs)));  