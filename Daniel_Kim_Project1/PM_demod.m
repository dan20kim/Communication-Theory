function [output] = PM_demod(input,Fc, Fs,k)
N = length(input);      
T = N/(Fs*ceil(3*Fc/Fs));
t = linspace(0,T,N);
wd = linspace(-pi,pi,N);
f = wd*(Fs*ceil(3*Fc/Fs))/(2*pi);
i_component = input.*sin(Fc*2*pi*t);
r_component = input.*cos(Fc*2*pi*t);


filter = ((2*pi*5000))./((1j*2*pi*f) + (2*pi*5000)); % first order low pass filter
I_s = fftshift(fft(i_component)/(Fs*ceil(3*Fc/Fs)));
R_s = fftshift(fft(r_component)/(Fs*ceil(3*Fc/Fs)));

I_filtered = I_s.*filter; % multiplication in frequency domain
i_filtered = ifft(fftshift(I_filtered)*Fs*ceil(3*Fc/Fs)); % convert back to time domain  % = Ac * sin(phase)/2

R_filtered = R_s.*filter; % multiplication in frequency domain
r_filtered = ifft(fftshift(R_filtered)*Fs*ceil(3*Fc/Fs)); % convert back to time domain = Ac * cos(phase)/2
test = atan(i_filtered./r_filtered)/k;


output = real(decimate(test,ceil(3*Fc/Fs))); 