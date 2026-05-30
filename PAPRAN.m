clc;
clear;
close all;

Nfft = 128;
NumSymbols = 10000;

PAPR = zeros(NumSymbols,1);

for n = 1:NumSymbols

    data = randi([0 3],Nfft,1);

    modData = exp(1j*pi/2*data);

    ofdmSignal = ifft(modData,Nfft);

    PAPR(n) = 10*log10( ...
        max(abs(ofdmSignal).^2) / ...
        mean(abs(ofdmSignal).^2));

end

paprRange = 0:0.05:14;

CCDF = zeros(size(paprRange));

for k = 1:length(paprRange)

    CCDF(k) = mean(PAPR > paprRange(k));

end

figure('Color','white');

semilogy(paprRange,CCDF,...
         'LineWidth',2.5);

grid on;
grid minor;
box on;

xlabel('PAPR (dB)');
ylabel('CCDF = P(PAPR > PAPR_0)');

title('CCDF Curve of OFDM Signal (QPSK)');

set(gca,'FontSize',12);

axis([4 14 1e-4 1]);