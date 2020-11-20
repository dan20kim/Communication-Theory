function [constellation] = Mary(symbol_num)
angles = linspace(0,2*pi,symbol_num + 1);
angles = angles(1:end-1);
constellation = cos(angles) + 1j*sin(angles);

end

