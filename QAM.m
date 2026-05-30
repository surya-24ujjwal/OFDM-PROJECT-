clc;
clear;
close all;

M = 16;
SNRdB = 0:2:20;

m = 2;
Omega = 1;

BER = zeros(size(SNRdB));

for k = 1:length(SNRdB)

    data = randi([0 M-1],100000,1);

    tx = qammod(data,M,...
        'gray',...
        'UnitAveragePower',true);

    h = sqrt(gamrnd(m,Omega/m,length(tx),1));

    fadedSignal = h .* tx;

    signalPower = mean(abs(fadedSignal).^2);

    snrLinear = 10^(SNRdB(k)/10);

    noisePower = signalPower/snrLinear;

    noise = sqrt(noisePower/2) .* ...
           (randn(size(tx)) + ...
            1j*randn(size(tx)));

    rx = fadedSignal + noise;

    rx = rx ./ h;

    rxData = qamdemod(rx,M,...
        'gray',...
        'UnitAveragePower',true);

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

title('BER vs SNR for 16-QAM under Nakagami-m Channel');

axis([0 20 1e-5 1]);