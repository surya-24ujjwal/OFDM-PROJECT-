clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    txBits = randi([0 1],Nbits,1);

    txSignal = 2*txBits - 1;

    snrLinear = 10^(SNRdB(k)/10);

    noise = sqrt(1/(2*snrLinear))*randn(Nbits,1);

    rxSignal = txSignal + noise;

    rxBits = rxSignal > 0;

    BER(k) = sum(txBits ~= rxBits)/Nbits;

end

figure;

semilogy(SNRdB,BER,'o-b',...
    'LineWidth',2,...
    'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)','FontSize',12);
ylabel('Bit Error Rate (BER)','FontSize',12);

title('BER vs SNR for BPSK under AWGN Channel',...
      'FontSize',13);

set(gca,'FontSize',11);