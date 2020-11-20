%% ECE300: Communication Theory HW 1
%% Question 6

% Author: Daniel Kim
% Professor: Brian L. Frost
% 9/8/20
clear; close all; clc;
N = 5000;% #samples
T = 20; % sec
fs = N/T;
t = linspace(-10,10,N);
rect = [zeros(1,floor(N/2)),ones(1,fs),zeros(1,floor(N/2)-fs)];
cosine = cos(2*pi*1*t);
x = rect.*cosine;
figure;
plot(t,x)
xlabel("Time (s)")
title("x(t)")
ylim([-1,1])
%%
% Pass x(t) into y
y = abs(circshift(x,-3*fs));
%%
% Take the FFT
X = fft(x);
Y = fft(y);
%%
% Shift and Scale
Xs = fftshift(X/fs);
Ys = fftshift(Y/fs);
%%
% Change the x axis to f
wd = linspace(-pi,pi,N);
	
f = wd*fs/(2*pi);
%%
% Plot
figure;
subplot(2,2,1);
plot(f,abs(Xs));
title("Magnitude of X(f)")
xlabel("Frequency (Hz)")
ylabel("|X(f)|")

subplot(2,2 ,2);
plot(f,abs(Ys));    
title("Magnitude of Y(f)")
xlabel("Frequency (Hz)")
ylabel("|Y(f)|")

subplot(2,2,3);
plot(f,unwrap(angle(Xs)));
title("Phase of X(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")
subplot(2,2,4);
plot(f,unwrap(angle(Ys)));
title("Phase of Y(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")
%%
% Get the norms of x and X
norm_time = (sum(abs(x).^2))*(T/N);
norm_freq = (sum(abs(Xs).^2))*(fs/N);
disp(['norm_time: ',num2str(norm_time)])
disp(['norm_freq: ',num2str(norm_freq)])
%%
% Both norms are ~.5, as expected. If the x axis was omega instead of f,
% there would be a scaling factor of 1/2pi
%% Question 7
% Create z, fft, shift and scale
z = y.*cos(64*pi*t+(pi/3));
Z = fft(z);
Zs = (fftshift(Z)/fs);
%%
% Plot
figure;
subplot(2,1,1);
plot(f,abs(Zs));
title("Magnitude of Z(f)")
xlabel("Frequency (Hz)")
ylabel("|Z(f)|")
subplot(2,1,2);
plot(f,unwrap(angle(Zs)));
title("Phase of Z(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")
%%
% The amplitude of Z(f) has 2 peaks at 32 Hz and -32 Hz whereas Y(f)
% had one peak. The peak value of the Y(f) plot is about twice as 
% large as the peak value in Z(f). The phase plots look relatively
% unchanged.

figure;
subplot(2,1,1);
plot(t,z);
title("Bandpass Signal (z(t))")
xlabel("Time (t)")
subplot(2,1,2);
plot(t,y);
title("Baseband Signal (y(t))")
xlabel("Time (t)")
%%
% Plot x,y,z
figure;
subplot (3,1,1);
plot(t,x)
title("x(t)")
subplot (3,1,2);
plot(t,y)
title("y(t)")
subplot (3,1,3);
plot(t,z)
title("z(t)")

%% Question 8
% Hilbert Transform
figure;
[hx,Hx] = HilbertTransform(x,f);
subplot(3,2,1);
plot(t,abs(hx));
title("hx(t)")
xlabel("Time (t)")
subplot(3,2,2);
plot(t,abs(Hx));
title("Hx(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")

[hy,Hy] = HilbertTransform(y,f);
subplot(3,2,3);
plot(t,abs(hy));
title("hy(t)")
xlabel("Time (t)")
subplot(3,2,4);
plot(t,abs(Hy));
title("Hy(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")

[hz,Hz] = HilbertTransform(z,f);
subplot(3,2,5);
plot(t,abs(hz));
title("hz(t)")
xlabel("Time (t)")
subplot(3,2,6);
plot(t,abs(Hz)); % wasn't sure if i should plot abs or real
title("Hz(f)")
xlabel("Frequency (Hz)")
ylabel("Radians")
%% Question 9
%%
% Show Orthogonality (take inner product and show it equals 0)
a = abs(dot(x,hx))*(T/N);
b = abs(dot(y,hy))*(T/N);
c = abs(dot(z,hz))*(T/N);
d = abs(dot(X,conj(Hx))*(fs/N));
e = abs(dot(Y,conj(Hy))*(fs/N));
g = abs(dot(Z,conj(Hz))*(fs/N));
disp(['a: ',num2str(a)])
disp(['b: ',num2str(b)])
disp(['c: ',num2str(c)])
disp(['d: ',num2str(d)])
disp(['e: ',num2str(e)])
disp(['g: ',num2str(g)])
%%
% All of the inner products of the signal and their hilbert transforms 
% are approximately 0, indicating that they are orthogonal.