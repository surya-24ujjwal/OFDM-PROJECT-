clc;
clear;
close all;

Nbits = 100000;
SNRdB = 0:2:20;

mValues = [0.5 1 2 4];
Omega = 1;

BER = zeros(length(mValues),length(SNRdB));

for mIndex = 1:length(mValues)

    m = mValues(mIndex);

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

        BER(mIndex,k) = ...
            sum(bits~=rxBits)/length(bits);

    end

end

figure('Color','white');

semilogy(SNRdB,BER(1,:),...
         'o-b',...
         'LineWidth',2,...
         'MarkerSize',8);
hold on;

semilogy(SNRdB,BER(2,:),...
         's-r',...
         'LineWidth',2,...
         'MarkerSize',8);

semilogy(SNRdB,BER(3,:),...
         'd-k',...
         'LineWidth',2,...
         'MarkerSize',8);

semilogy(SNRdB,BER(4,:),...
         '^-m',...
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

title('BER Performance for Different Values of Nakagami Parameter (QPSK)',...
      'FontSize',14,...
      'FontWeight','bold');

legend('m = 0.5',...
       'm = 1',...
       'm = 2',...
       'm = 4',...
       'Location','southwest');

set(gca,'FontSize',12);

axis([0 20 1e-5 1]);

exportgraphics(gcf,...
'Figure_5_6_Nakagami_m_Comparison.png',...
'Resolution',300);