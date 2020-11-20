%% Hilbert Transform Function
function [tout, fout] = HilbertTransform(in, f)
    fout = fftshift(fft(in)).*sign(f).*-1i;
    tout = real(ifft(fftshift(fout)));
end