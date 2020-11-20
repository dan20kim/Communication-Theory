function [output] = powerdB(input,Fs)
output = 10*log10(rms(input)^2);