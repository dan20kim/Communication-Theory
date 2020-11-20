function [output] = c_AM_mod(Ac, input, a, Fc, Fs)
t = linspace(0,length(input)/Fs,length(input));
tq = linspace(0,length(input)/Fs,length(input)*ceil(3*Fc/Fs));
inputq = interp1(t,input,tq,'linear','extrap');
output = Ac*(1+a*inputq).*cos(2*pi*Fc*tq);
