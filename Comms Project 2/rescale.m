function [noise_free_scaled, estimated_symbols] = rescale(noise_free, base_constellation, N_o, SNR)
M = length(base_constellation);
N = length(noise_free);
E_bavg = (10^(SNR/10))*N_o/2; %E_bavg
Es = log2(M)*E_bavg; %E_avg

E_current_avg = sum(abs(base_constellation.^2))/M;

scale = sqrt(Es)/sqrt(E_current_avg);
constellation_scaled = base_constellation.*scale; %sqrt(scale) 
noise_free_scaled = noise_free.*scale;

noise_imaginary = sqrt(N_o/4)*randn(1,N);
noise_real = sqrt(N_o/4)*randn(1,N);

noisy = noise_free_scaled + (noise_imaginary*1j + noise_real);
estimated_symbols = least_squares(noisy,constellation_scaled);

end

