function [true_symbols, estimated_symbols] = rescale_diff(noise_free, base_constellation, N_o, SNR)
M = length(base_constellation);
N = length(noise_free);
E_avg = (10^(SNR/10))*N_o/2; %SNR per bit (linear) and noise power
E_bavg = log2(M)*E_avg; %desired energy

E_current_avg = sum(abs(base_constellation.^2))/M; % total energy of cnstlt

scale = sqrt(E_bavg)/sqrt(E_current_avg);
constellation_scaled = base_constellation.*scale;
noise_free_scaled = noise_free.*scale;

noise_imaginary = sqrt(N_o/4)*randn(1,N);
noise_real = sqrt(N_o/4)*randn(1,N);

%we will now make a phase constellation based on angle between the stars of
%the scaled constellation
angle_constellation = atan2(imag(constellation_scaled),real(constellation_scaled));
angle_constellation(angle_constellation<0) = angle_constellation(angle_constellation<0) + 2*pi;
minimum = min(angle_constellation);
angle_constellation = angle_constellation - minimum; %0 phase is lowest
angle_constellation = [angle_constellation 2*pi]; %stop bounds issue

%add noise to the symbols
noisy = noise_free_scaled + (noise_imaginary*1j + noise_real);

% For Noise
%find the angles between the symbols
angle_noisy = atan2(imag(noisy),real(noisy));
angle_noisy(angle_noisy<0) = angle_noisy(angle_noisy<0) + 2*pi;
angle_noisy = diff(angle_noisy);
angle_noisy(angle_noisy<0) = angle_noisy(angle_noisy<0) + 2*pi;

estimated_symbols = least_squares(angle_noisy,angle_constellation);
estimated_symbols(estimated_symbols == 2*pi) = 0; %% make the 2pi terms 0

% No Noise
angle_noisefree = atan2(imag(noise_free_scaled),real(noise_free_scaled));
angle_noisefree(angle_noisefree<0) = angle_noisefree(angle_noisefree<0) + 2*pi;
angle_noisefree = diff(angle_noisefree);
angle_noisefree(angle_noisefree<0) = angle_noisefree(angle_noisefree<0) + 2*pi;

true_symbols = least_squares(angle_noisefree,angle_constellation);
true_symbols(true_symbols == 2*pi) = 0; %% make the 2pi terms 0

end