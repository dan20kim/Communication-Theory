function [out] = pre_perror(base_constellation, N_o, SNR)
%the output of this function is put into qfunc
M = length(base_constellation);
E_bavg = (10^(SNR/10))*N_o/2; %E_bavg
Es = log2(M)*E_bavg; %E_avg
out = sqrt(Es/N_o);

end