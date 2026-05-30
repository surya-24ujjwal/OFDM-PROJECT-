clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    bits = randi([0 1],Nbits,1);

    bits = bits(1:floor(length(bits)/2)*2);

    I = 2*bits(1:2:end)-1;
    Q = 2*bits(2:2:end)-1;

    txSignal = (I + 1j*Q)/sqrt(2);

    snrLinear = 10^(SNRdB(k)/10);

    noise = sqrt(1/(2*snrLinear))*...
           (randn(size(txSignal)) + ...
            1j*randn(size(txSignal)));

    rxSignal = txSignal + noise;

    rxBits = zeros(length(bits),1);

    rxBits(1:2:end) = real(rxSignal) > 0;
    rxBits(2:2:end) = imag(rxSignal) > 0;

    BER(k) = sum(bits ~= rxBits)/length(bits);

end

figure;

semilogy(SNRdB,BER,'s-r',...
         'LineWidth',2,...
         'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)','FontSize',12);
ylabel('Bit Error Rate (BER)','FontSize',12);

title('BER vs SNR for QPSK under AWGN Channel',...
      'FontSize',13);

set(gca,'FontSize',11);