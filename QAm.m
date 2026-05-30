clc;
clear;
close all;

M = 16;
SNRdB = 0:2:20;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    data = randi([0 M-1],100000,1);

    tx = qammod(data,M,'gray','UnitAveragePower',true);

    rx = awgn(tx,SNRdB(k),'measured');

    rxData = qamdemod(rx,M,'gray','UnitAveragePower',true);

    [~,BER(k)] = biterr(data,rxData);

end

figure;

semilogy(SNRdB,BER,'d-k',...
         'LineWidth',2,...
         'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BER vs SNR for 16-QAM under AWGN Channel');

axis([0 20 1e-5 1]);