function [output] = FM_demod(input,Fc, Fs,k)
N = length(input);
L = ceil(15*Fc/Fs);
Fs2 = (Fs*L);
T = N/Fs2;
t = linspace(0,T,N);
wd = linspace(-pi,pi,N);
f = wd*Fs2/(2*pi);
INPUT = fftshift(fft(input));
INPUT = INPUT.*(1j*2*pi*f);
input2 = ifft(ifftshift(INPUT));
input2(input2<0) = 0;
INPUT_RECTIFIED_s = fftshift(fft(input2));
filter = ((2*pi*1000))./((1j*2*pi*f) + (2*pi*1000)); % first order low pass filter
filter2 = ((2*pi*1000))./((1j*2*pi*f) + (2*pi*1000)); % first order low pass filter
high_pass = ((1j*2*pi*f)*(1/(2*pi*20)))./(1+((1j*2*pi*f)*(1/(2*pi*20))));
INPUT_filtered = INPUT_RECTIFIED_s.*filter.*filter2.*high_pass;
input3 = real(ifft(ifftshift(INPUT_filtered)));
input3 = input3/(2*pi*k);
output = sqrt(20.82)*decimate(input3,L);


