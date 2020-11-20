%% AutoCorreltation Function
function [rx, psd] = AutoCorrelation(x,M)
    w=linspace(-pi*1000,pi*1000,10001);
    N = numel(x); % get length of x
    positive_half = zeros(1,M+1); % split output in half, equation given piece-wise
    negative_half = zeros(1,M);
    % autocorrelation equation for m >= 0
    for m = 0:M
        x1 = x(1:N-m);
        x2 = x(1+m:N);
        positive_half(m+1) = (1/(N-m))*sum(x1.*x2); 
    end
    % autocorrelation equation for m < 0
    for m = -M:-1
        x1 = x(abs(m)+1:N);
        x2 = x(1:N+m);
        negative_half(M+m+1) = (1/(N-abs(m)))*sum(x1.*x2);
    end 
    rx = [negative_half positive_half];
    psd = zeros(1,length(w));
    % psd equation (DFT)
    for m = -M:M
        psd = psd + rx(m+M+1).*exp((-1j*w*m)./(2*M+1));
    end
end