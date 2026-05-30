clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

BER_BPSK = zeros(size(SNRdB));
BER_QPSK = zeros(size(SNRdB));
BER_16QAM = zeros(size(SNRdB));

%% BPSK

for i = 1:length(SNRdB)

    txBits = randi([0 1],Nbits,1);

    txSignal = 2*txBits - 1;

    snrLinear = 10^(SNRdB(i)/10);

    noise = sqrt(1/(2*snrLinear))*randn(size(txSignal));

    rxSignal = txSignal + noise;

    rxBits = rxSignal > 0;

    BER_BPSK(i) = sum(txBits~=rxBits)/Nbits;

end

%% QPSK

for i = 1:length(SNRdB)

    bits = randi([0 1],Nbits,1);

    bits = bits(1:floor(length(bits)/2)*2);

    I = 2*bits(1:2:end)-1;
    Q = 2*bits(2:2:end)-1;

    txSignal = (I + 1j*Q)/sqrt(2);

    snrLinear = 10^(SNRdB(i)/10);

    noise = sqrt(1/(2*snrLinear))*...
           (randn(size(txSignal)) + ...
            1j*randn(size(txSignal)));

    rxSignal = txSignal + noise;

    rxBits = zeros(length(bits),1);

    rxBits(1:2:end) = real(rxSignal)>0;
    rxBits(2:2:end) = imag(rxSignal)>0;

    BER_QPSK(i) = sum(bits~=rxBits)/length(bits);

end

%% 16-QAM

%% 16-QAM

M = 16;

for i = 1:length(SNRdB)

    data = randi([0 M-1],100000,1);

    tx = qammod(data,M,...
        'gray',...
        'UnitAveragePower',true);

    rx = awgn(tx,SNRdB(i),'measured');

    rxData = qamdemod(rx,M,...
        'gray',...
        'UnitAveragePower',true);

    [~,BER_16QAM(i)] = biterr(data,rxData);



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

title('BER Performance of BPSK, QPSK and 16-QAM over AWGN Channel',...
      'FontSize',14,...
      'FontWeight','bold');

legend('BPSK',...
       'QPSK',...
       '16-QAM',...
       'Location','southwest');

set(gca,'FontSize',12);

axis([0 20 1e-5 1]);

