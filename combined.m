clc;
clear;
close all;

SNRdB = 0:2:20;

m = 2;
Omega = 1;

BER_BPSK = zeros(size(SNRdB));
BER_QPSK = zeros(size(SNRdB));
BER_16QAM = zeros(size(SNRdB));

%% BPSK

Nbits = 100000;

for k = 1:length(SNRdB)

    bits = randi([0 1],Nbits,1);

    tx = 2*bits - 1;

    h = sqrt(gamrnd(m,Omega/m,Nbits,1));

    fadedSignal = h .* tx;

    snrLinear = 10^(SNRdB(k)/10);

    signalPower = mean(abs(fadedSignal).^2);

    noisePower = signalPower/snrLinear;

    noise = sqrt(noisePower/2)*randn(Nbits,1);

    rx = fadedSignal + noise;

    rx = rx ./ h;

    rxBits = rx > 0;

    BER_BPSK(k) = sum(bits~=rxBits)/Nbits;

end

%% QPSK

for k = 1:length(SNRdB)

    bits = randi([0 1],Nbits,1);

    bits = bits(1:floor(length(bits)/2)*2);

    I = 2*bits(1:2:end)-1;
    Q = 2*bits(2:2:end)-1;

    tx = (I + 1j*Q)/sqrt(2);

    h = sqrt(gamrnd(m,Omega/m,length(tx),1));

    fadedSignal = h .* tx;

    snrLinear = 10^(SNRdB(k)/10);

    signalPower = mean(abs(fadedSignal).^2);

    noisePower = signalPower/snrLinear;

    noise = sqrt(noisePower/2) .* ...
           (randn(size(tx)) + ...
            1j*randn(size(tx)));

    rx = fadedSignal + noise;

    rx = rx ./ h;

    rxBits = zeros(length(bits),1);

    rxBits(1:2:end) = real(rx) > 0;
    rxBits(2:2:end) = imag(rx) > 0;

    BER_QPSK(k) = sum(bits~=rxBits)/length(bits);

end

%% 16-QAM

M = 16;

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

    [~,BER_16QAM(k)] = biterr(data,rxData);

end

%% Plot

figure('Color','white');

semilogy(SNRdB,BER_BPSK,...
    'o-b',...
    'LineWidth',2,...
    'MarkerSize',8);

hold on;

semilogy(SNRdB,BER_QPSK,...
    's-r',...
    'LineWidth',2,...
    'MarkerSize',8);

semilogy(SNRdB,BER_16QAM,...
    'd-k',...
    'LineWidth',2,...
    'MarkerSize',8);

grid on;
grid minor;
box on;

xlabel('SNR (dB)',...
       'FontSize',13,...
       'FontWeight','bold');

ylabel('Bit Error Rate (BER)',...
       'FontSize',13,...
       'FontWeight','bold');

title('BER Performance of BPSK, QPSK and 16-QAM over Nakagami-m Channel (m = 2)',...
      'FontSize',14,...
      'FontWeight','bold');

legend('BPSK',...
       'QPSK',...
       '16-QAM',...
       'Location','southwest');

set(gca,'FontSize',12);

axis([0 20 1e-5 1]);

exportgraphics(gcf,...
'Figure_5_3_Nakagami_Comparison.png',...
'Resolution',300);