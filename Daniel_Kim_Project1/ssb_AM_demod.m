function [output] = ssb_AM_demod(input, Fc, Fs)
N = length(input);
T = N/(Fs*(ceil(3*Fc/Fs)));
wd = linspace(-pi,pi,N);
f = wd*Fs*(ceil(3*Fc/Fs))/(2*pi);
t = linspace(0,T,N);
Fs2 = (Fs*ceil(3*Fc/Fs));
filter = ((2*pi*4000))./((1j*2*pi*f) + (2*pi*4000)); %first order low pass filter
high_pass = ((1j*2*pi*f)*(1/(2*pi*20)))./(1+((1j*2*pi*f)*(1/(2*pi*20))));
input2 = input.*cos(2*pi*Fc*t);

INPUT_ssb_s = (fftshift(fft(input2)/Fs2));
INPUT_filtered = INPUT_ssb_s.*filter.*high_pass;

input_filtered = ifft(ifftshift(INPUT_filtered)*Fs2);
output = sqrt(8.625)*real(decimate(input_filtered,ceil(3*Fc/Fs)));


