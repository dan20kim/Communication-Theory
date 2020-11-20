%Dan Kim, Tony Belladonna, Philip Blumin, Paul Cucchiara
%The Cooper Union
%Professor Frost
%Problems 6-8
%% Clear stage
clear;
clc;
close all;

%% Problem 6

PSK_prob_2 = zeros(1,25);
PSK_prob_4 = PSK_prob_2;
PSK_prob_8 = PSK_prob_2;
PSK_prob_16 = PSK_prob_2;
PSK_prob_32 = PSK_prob_2;

perror_PSK_2 = PSK_prob_2;
perror_PSK_4 = PSK_prob_2;
perror_PSK_8 = PSK_prob_2;
perror_PSK_16 = PSK_prob_2;
perror_PSK_32 = PSK_prob_2;

N_o = 10;

tstart1 = tic;
%2
constellation_2 = Mary(2);
input_2 = repmat(constellation_2,1,100000/2);
input_2(randperm(100000)) =  input_2(randperm(100000));

%4
constellation_4 = Mary(4);
input_4 = repmat(constellation_4,1,100000/4);
input_4(randperm(100000)) =  input_4(randperm(100000));

%8
constellation_8 = Mary(8);
input_8 = repmat(constellation_8,1,100000/8);
input_8(randperm(100000)) =  input_8(randperm(100000));

%16
constellation_16 = Mary(16);
input_16 = repmat(constellation_16,1,100000/16);
input_16(randperm(100000)) =  input_16(randperm(100000));

%32
constellation_32 = Mary(32);
input_32 = repmat(constellation_32,1,100000/32);
input_32(randperm(100000)) =  input_32(randperm(100000));

for SNR = -4:20
    %PSK 2
    [noise_free, estimated] = rescale(input_2, constellation_2, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    PSK_prob_2(SNR+5) = percentage;
    
    %PSK 4
    [noise_free, estimated] = rescale(input_4, constellation_4, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    PSK_prob_4(SNR+5) = percentage;
    
    %PSK 8
    [noise_free, estimated] = rescale(input_8, constellation_8, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    PSK_prob_8(SNR+5) = percentage;
    
    %PSK 16
    [noise_free, estimated] = rescale(input_16, constellation_16, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    PSK_prob_16(SNR+5) = percentage;
    
    %PSK 32
    [noise_free, estimated] = rescale(input_32, constellation_32, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    PSK_prob_32(SNR+5) = percentage;
 
end

%Plot for PSK
x_axis = [-4:20];

figure
scatter(x_axis,PSK_prob_2,'b','filled');
hold on
scatter(x_axis,PSK_prob_4,'r','filled');
scatter(x_axis,PSK_prob_8,'g','filled');
scatter(x_axis,PSK_prob_16,'m','filled');
scatter(x_axis,PSK_prob_32,'k','filled');
hold off
legend('2-ary PSK','4-ary PSK','8-ary PSK','16-ary PSK', '32-ary PSK')
xticks([-4 0 4 8 12 16 20])
title('Problem 6')
xlabel('SNR Per Bit')
ylabel('Probablilty of Error')

tend1 = toc(tstart1);
disp("Time taken in seconds for problem 6: " + tend1 );

%% Problem 7

DPSK_prob_2 = zeros(1,25);
DPSK_prob_4 = DPSK_prob_2;
DPSK_prob_8 = DPSK_prob_2;
DPSK_prob_16 = DPSK_prob_2;
DPSK_prob_32 = DPSK_prob_2;

perror_DPSK_2 = DPSK_prob_2;
perror_DPSK_4 = DPSK_prob_2;
perror_DPSK_8 = DPSK_prob_2;
perror_DPSK_16 = DPSK_prob_2;
perror_DPSK_32 = DPSK_prob_2;

N_o = 10;

tstart2 = tic;
%2
constellation_2 = Mary(2);
input_2 = repmat(constellation_2,1,100000/2);
input_2(randperm(100000)) =  input_2(randperm(100000));

%4
constellation_4 = Mary(4);
input_4 = repmat(constellation_4,1,100000/4);
input_4(randperm(100000)) =  input_4(randperm(100000));

%8
constellation_8 = Mary(8);
input_8 = repmat(constellation_8,1,100000/8);
input_8(randperm(100000)) =  input_8(randperm(100000));

%16
constellation_16 = Mary(16);
input_16 = repmat(constellation_16,1,100000/16);
input_16(randperm(100000)) =  input_16(randperm(100000));

%32
constellation_32 = Mary(32);
input_32 = repmat(constellation_32,1,100000/32);
input_32(randperm(100000)) =  input_32(randperm(100000));

for SNR = -4:20
    
    %DSPK 4
    [true, estimated] = rescale_diff(input_4, constellation_4, N_o, SNR);
    percentage = percent_error(true, estimated);
    DPSK_prob_4(SNR+5) = percentage;
    
    %DSPK 8
    [true, estimated] = rescale_diff(input_8, constellation_8, N_o, SNR);
    percentage = percent_error(true, estimated);
    DPSK_prob_8(SNR+5) = percentage;
    
    %DSPK 16
    [true, estimated] = rescale_diff(input_16, constellation_16, N_o, SNR);
    percentage = percent_error(true, estimated);
    DPSK_prob_16(SNR+5) = percentage;
    
    %DSPK 32
    [true, estimated] = rescale_diff(input_32, constellation_32, N_o, SNR);
    percentage = percent_error(true, estimated);
    DPSK_prob_32(SNR+5) = percentage;
end

%Plot for DPSK
x_axis = [-4:20];

figure
scatter(x_axis,DPSK_prob_4,'b','filled');
hold on
scatter(x_axis,DPSK_prob_8,'r','filled');
scatter(x_axis,DPSK_prob_16,'m','filled');
scatter(x_axis,DPSK_prob_32,'k','filled');
hold off
legend('4-ary DPSK','8-ary DPSK','16-ary DPSK', '32-ary DPSK')
xticks([-4 0 4 8 12 16 20])
title('Problem 7')
xlabel('SNR Per Bit')
ylabel('Probablilty of Error')

tend2 = toc(tstart2);
disp("Time taken in seconds for problem 7: " + tend2);

%% Problem 8

QAM_prob_4 = zeros(1,25);
QAM_prob_16 = PSK_prob_4;
QAM_prob_32 = PSK_prob_4;
QAM_prob_64 = PSK_prob_4;

N_o = 10;

tstart3 = tic;
%4
constellation_4 = qam(4);
input_4 = repmat(constellation_4,1,100000/4);
input_4(randperm(100000)) =  input_4(randperm(100000));

%16
constellation_16 = qam(16);
input_16 = repmat(constellation_16,1,100000/16);
input_16(randperm(100000)) =  input_16(randperm(100000));

%32
constellation_32 = qam(32);
input_32 = repmat(constellation_32,1,100000/32);
input_32(randperm(100000)) =  input_32(randperm(100000));

%64
constellation_64 = qam(64);
input_64 = repmat(constellation_64,1,ceil(100000/64));
input_64(randperm(100000)) =  input_64(randperm(100000));

for SNR = -4:20
    %PSK 4
    [noise_free, estimated] = rescale(input_4, constellation_4, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    QAM_prob_4(SNR+5) = percentage;
    
    
    %PSK 16
    [noise_free, estimated] = rescale(input_16, constellation_16, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    QAM_prob_16(SNR+5) = percentage;
    
    %PSK 32
    [noise_free, estimated] = rescale(input_32, constellation_32, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    QAM_prob_32(SNR+5) = percentage;
    
    %PSK 64
    [noise_free, estimated] = rescale(input_64, constellation_64, N_o, SNR);
    percentage = percent_error(noise_free, estimated);
    QAM_prob_64(SNR+5) = percentage;
    
end

%Plots for QAM
x_axis = [-4:20];

figure
scatter(x_axis,QAM_prob_4,'b','filled');
hold on
scatter(x_axis,QAM_prob_16,'r','filled');
scatter(x_axis,QAM_prob_32,'g','filled');
scatter(x_axis,QAM_prob_64,'m','filled');
hold off
legend('4-QAM','16-QAM','32-QAM','64-QAM')
xticks([-4 0 4 8 12 16 20])
title('Problem 8')
xlabel('SNR Per Bit')
ylabel('Probablilty of Error')

tend3 = toc(tstart3);
disp("Time taken in seconds for problem 8: " + tend3 );

%% comfirming QAM works
r = real(qam(64));
i = imag(qam(64));
figure;
plot(r,i, 'o')

