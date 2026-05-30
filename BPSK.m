clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    txBits = randi([0 1],Nbits,1);

    txSignal = 2*txBits - 1;

    h = (randn(Nbits,1) + 1j*randn(Nbits,1))/sqrt(2);

    fadedSignal = h .* txSignal;

    snrLinear = 10^(SNRdB(k)/10);

    noise = sqrt(1/(2*snrLinear))*...
           (randn(Nbits,1) + 1j*randn(Nbits,1));

    rxSignal = fadedSignal + noise;

    rxSignal = rxSignal ./ h;

    rxBits = real(rxSignal) > 0;

    BER(k) = sum(txBits ~= rxBits)/Nbits;

end

figure;

semilogy(SNRdB,BER,'o-b',...
         'LineWidth',2,...
         'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BER vs SNR for BPSK under Rayleigh Fading Channel');

axis([0 20 1e-5 1]);