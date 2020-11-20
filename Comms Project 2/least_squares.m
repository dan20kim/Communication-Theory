function [output] = least_squares(noisy, constellation)
%takes in a noisy and constellation vector 
%outputs N length estimated symbol vector
N = length(noisy);
noisy_2 = repmat(noisy,length(constellation),1);
constellation_2 = repmat(constellation, N,1).';
difference = (noisy_2 - constellation_2).^2;
[M,I] = min(difference,[],'linear');
output = constellation_2(I);

end

