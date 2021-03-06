function [output] = ssb_AM_mod(input, Fc, Fs, Ac)
N = length(input);
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0,T,N*ceil(3*Fc/Fs));
wdq = linspace(-pi,pi,N*(ceil(3*Fc/Fs)));
Fsq = Fs*(ceil(3*Fc/Fs));
fq = wdq*Fsq/(2*pi);
inputq = interp1(t,input,tq,'linear','extrap');
output = (Ac*inputq.*cos(2*pi*Fc*tq) - Ac*HilbertTransform(inputq,fq).*sin(2*pi*Fc*tq)) + cos(2*pi*Fc*tq);