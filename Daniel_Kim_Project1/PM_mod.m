function [output] = PM_mod(input, Ac, Fc, Fs, k)
N = length(input);
T = N/Fs;
t = linspace(0,T,N);
tq = linspace(0, T, N*ceil(3*Fc/Fs));
inputq = interp1(t,input,tq,'linear','extrap');
delta = k.*inputq;
output = Ac.*cos(2*pi*Fc*tq  + delta) + cos(2*pi*Fc*tq); 
