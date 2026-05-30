clc;
clear;
close all;

%% PARAMETERS

Nfft = 128;
NumSymbols = 10000;      % Increased for smoother CCDF

papr_bpsk  = zeros(NumSymbols,1);
papr_qpsk  = zeros(NumSymbols,1);
papr_16qam = zeros(NumSymbols,1);

%% ==========================
%% BPSK OFDM
%% ==========================

for n = 1:NumSymbols

    data = randi([0 1],Nfft,1);

    modData = 2*data - 1;

    tx = ifft(modData,Nfft);

    papr_bpsk(n) = 10*log10( ...
        max(abs(tx).^2) / mean(abs(tx).^2));

end

%% ==========================
%% QPSK OFDM
%% ==========================

for n = 1:NumSymbols

    data = randi([0 3],Nfft,1);

    modData = exp(1j*pi/2*data);

    tx = ifft(modData,Nfft);

    papr_qpsk(n) = 10*log10( ...
        max(abs(tx).^2) / mean(abs(tx).^2));

end

%% ==========================
%% 16-QAM OFDM
%% ==========================

for n = 1:NumSymbols

    data = randi([0 15],Nfft,1);

    modData = qammod(data,16,...
        'UnitAveragePower',true);

    tx = ifft(modData,Nfft);

    papr_16qam(n) = 10*log10( ...
        max(abs(tx).^2) / mean(abs(tx).^2));

end

%% ==========================
%% CCDF
%% ==========================

paprRange = 0:0.05:14;

ccdf_bpsk  = zeros(size(paprRange));
ccdf_qpsk  = zeros(size(paprRange));
ccdf_16qam = zeros(size(paprRange));

for k = 1:length(paprRange)

    ccdf_bpsk(k) = ...
        mean(papr_bpsk > paprRange(k));

    ccdf_qpsk(k) = ...
        mean(papr_qpsk > paprRange(k));

    ccdf_16qam(k) = ...
        mean(papr_16qam > paprRange(k));

end

%% ==========================
%% PLOT
%% ==========================

figure('Color','white');

semilogy(paprRange,...
         ccdf_bpsk,...
         'LineWidth',2.5);
hold on;

semilogy(paprRange,...
         ccdf_qpsk,...
         'LineWidth',2.5);

semilogy(paprRange,...
         ccdf_16qam,...
         'LineWidth',2.5);

grid on;
grid minor;
box on;

xlabel('PAPR (dB)',...
       'FontSize',13,...
       'FontWeight','bold');

ylabel('CCDF = P(PAPR > PAPR_0)',...
       'FontSize',13,...
       'FontWeight','bold');

title('PAPR Comparison of OFDM Signals',...
      'FontSize',14,...
      'FontWeight','bold');

legend('BPSK',...
       'QPSK',...
       '16-QAM',...
       'Location','southwest');

set(gca,...
    'FontSize',12,...
    'LineWidth',1.2);

axis([4 14 1e-4 1]);

exportgraphics(gcf,...
'Figure_5_8_PAPR_Comparison.png',...
'Resolution',300);