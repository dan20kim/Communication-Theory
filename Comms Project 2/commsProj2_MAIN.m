%Dan Kim, Tony Belladonna, Philip Blumin, Paul Cucchiara
%The Cooper Union
%Professor Frost
%Problems 1-6
%% Clear Stage
clc; 
clear; 
close all;

%% Question 1

input = [3,1+5j,1-6j,-7,142];
constellation = [1,-1,1j,-1j];
disp("Output of least squares function: ");
least_squares(input,constellation)

%% Question 2

constellation = [1 1j];
%select 100 random symbols from the constellation
input = repmat(constellation,1,5000);
input(randperm(10000)) =  input(randperm(10000));
SNR = 20;
N_o = 10;
[noise_free, estimated] = rescale(input, constellation, N_o, SNR);

%% Question 3

percentage = percent_error(noise_free, estimated);
disp("Percent error for question 3: " + percentage);
%As seen for high SNR the percent error approaches to 0
%% Question 4

constellation = [1 -1 1j -1j];
input = repmat(constellation,1,50000);
input(randperm(100000)) =  input(randperm(100000));
SNR = 20;
N_o = 10;
[true, estimated] = rescale_diff(abs(input), constellation, N_o, SNR);
percentage1 = percent_error(true, estimated);
disp("Percent error for question 4: " + percentage1);
%As seen for high SNR the percent error approaches to 0 for our
%differential scheme
%% Gradification Stage

disp('pat pat');
disp('slurp');

%% Question 5

%Binary Antipodal
Antipodal_PSK_prob = zeros(1,25);
Antipodal_DPSK_prob = Antipodal_PSK_prob;
Orthogonal_PSK_prob = Antipodal_PSK_prob;
Orthogonal_DPSK_prob = Antipodal_PSK_prob;
perror_anti_PSK = Antipodal_PSK_prob;
perror_anti_DPSK = Antipodal_PSK_prob;
perror_orth_PSK = Antipodal_PSK_prob;
perror_orth_DPSK = Antipodal_PSK_prob;

N_o = 10;

constellation_anti = [1j -1j];
input_anti = repmat(constellation_anti,1,50000);
input_anti(randperm(100000)) =  input_anti(randperm(100000));

constellation_orth = [1 1j];
input_orth = repmat(constellation_orth,1,50000);
input_orth(randperm(100000)) =  input_orth(randperm(100000));

for SNR = -4:20
    %Antipodal
    %PSK
    [noise_free, estimated] = rescale(input_anti, constellation_anti, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    Antipodal_PSK_prob(SNR+5) = percentage;
    
    %perror for antipodal psk
    [out] = pre_perror(constellation_anti, N_o, SNR);
    perror_anti_PSK(SNR+5) = qfunc(sqrt(2)*out);
    
    %Orthogonal 
    %PSK
    [noise_free, estimated] = rescale(input_orth, constellation_orth, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    Orthogonal_PSK_prob(SNR+5) = percentage;
    
    %perror for orthogonal psk
    [out1] = pre_perror(constellation_orth, N_o, SNR);
    perror_orth_PSK(SNR+5) = qfunc(out1);
    
end

%Plots for Binary Antipodal for PSK and DPSK
x_axis = [-4:20];

figure
%subplot(2,1,1)
scatter(x_axis,Antipodal_PSK_prob,50,'b','filled');
hold on
scatter(x_axis,Orthogonal_PSK_prob,50,'r','filled');
% scatter(x_axis,Antipodal_DPSK_prob,'r','filled','d');
hold off
legend('Binary Antipodal','Binary Orthogonal','Location','East')
xticks([-4 0 4 8 12 16 20])
title('Experimental Probability of Error')
xlabel('SNR Per Bit')
ylabel('Probablilty of Error')

%Binary Antipodal errors
%subplot(2,1,2)
figure;
scatter(x_axis,perror_anti_PSK,50,'b','filled');
hold on
scatter(x_axis,perror_orth_PSK,50,'r','filled');
% scatter(x_axis,perror_anti_DPSK,'r','filled','d');
hold off
legend('Binary Antipodal','Binary Orthogonal','Location','East')
xticks([-4 0 4 8 12 16 20])
title('Theoretical Probability of Error')
xlabel('SNR Per Bit')
ylabel('Probablilty of Error')

%% Problem 6

cons = qam(4);
input = repmat(constellation,1,50000);
input(randperm(100000)) =  input(randperm(100000));
SNR = 20;
N_o = 10;
[true, estimated] = rescale_diff(input, cons, N_o, SNR);
percentage3 = percent_error(true, estimated);
disp("Percent error for question 6: " + percentage3);

