clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

m = 2;
Omega = 1;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    bits = randi([0 1],Nbits,1);

    txSignal = 2*bits - 1;

    h = sqrt(gamrnd(m,Omega/m,Nbits,1));

    fadedSignal = h .* txSignal;

    snrLinear = 10^(SNRdB(k)/10);

    signalPower = mean(abs(fadedSignal).^2);

    noisePower = signalPower/snrLinear;

    noise = sqrt(noisePower/2)*randn(Nbits,1);

    rxSignal = fadedSignal + noise;

    rxSignal = rxSignal ./ h;

    rxBits = rxSignal > 0;

    BER(k) = sum(bits~=rxBits)/Nbits;

end

figure;

semilogy(SNRdB,BER,'o-b',...
         'LineWidth',2,...
         'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BER vs SNR for BPSK under Nakagami-m Channel');

axis([0 20 1e-5 1]);