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

    bits = bits(1:floor(length(bits)/2)*2);

    I = 2*bits(1:2:end)-1;
    Q = 2*bits(2:2:end)-1;

    txSignal = (I + 1j*Q)/sqrt(2);

    h = sqrt(gamrnd(m,Omega/m,length(txSignal),1));

    fadedSignal = h .* txSignal;

    snrLinear = 10^(SNRdB(k)/10);

    signalPower = mean(abs(fadedSignal).^2);

    noisePower = signalPower/snrLinear;

    noise = sqrt(noisePower/2) .* ...
           (randn(size(txSignal)) + ...
            1j*randn(size(txSignal)));

    rxSignal = fadedSignal + noise;

    rxSignal = rxSignal ./ h;

    rxBits = zeros(length(bits),1);

    rxBits(1:2:end) = real(rxSignal) > 0;
    rxBits(2:2:end) = imag(rxSignal) > 0;

    BER(k) = sum(bits~=rxBits)/length(bits);

end

figure;

semilogy(SNRdB,BER,'s-r',...
         'LineWidth',2,...
         'MarkerSize',8);

grid on;
box on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('BER vs SNR for QPSK under Nakagami-m Channel');

axis([0 20 1e-5 1]);