clc
clear all
close all


G = [
    1 0 1 1 0;
    0 1 0 1 1];

H = [
    1 0 1 0 0;
    1 1 0 1 0;
    0 1 0 0 1];

[k, n] = size(G);

Phi = [
    0 0 0 0 0;
    0 0 1 0 0;
    0 0 0 1 0;
    1 0 0 0 0;
    0 0 0 0 1;
    0 0 1 0 1;
    0 1 0 0 0;
    0 1 1 0 0];
%
% numberOfBitErrors = 0;
% numberOfWorderrors = 0;
% Nframes = 0;

WER = [ ];
% BER = [];
for i=1:10

    numberOfBitErrors = 0;
    numberOfWorderrors = 0;
    Nframes = 0;
    R = k / n;
    EbNodB = i;                 %dB variable
    EbNo = 10^(EbNodB / 10);
    var = 1 / (2 * EbNo * R);
    %var = ceil(var);
    %sqrt(var)

    Nstop = 1000;

    while Nframes < Nstop
        %         numberOfBitErrors =0;
        %         nbe = 0;
        %         numberOfWorderrors=0;
        u = randi([0 1], 1, k);
        c = mod(u * G, 2);
        c1 = 1 - 2 * c;

        e = randn(1,n) * sqrt(var);
        y = c1 + e;
        y(y<0) = -1;
        y(y>0) = 1;

        s1 = (y - 1) / 2;
        s1 = abs(s1);
        s = mod(s1 * H', 2);
        ss = bi2de(s)+1;
        ehat = Phi(ss,:);

        chat = mod(s1 - ehat, 2);

        nbe = sum(mod(c -chat,2));
        numberOfBitErrors = numberOfBitErrors +nbe;
        numberOfWorderrors = numberOfWorderrors + (nbe > 0);
        nowr=numberOfWorderrors /Nstop;
        Nframes = Nframes + 1;
        %       WER = numberOfWorderrors
        %       BER = numberOfBitErrors

    end
    WER = [WER nowr];
    %     BER = [BER, numberOfBitErrors];
end

% WER =  log10(WER);
plot(WER);
hold on 
grid on
set(gca,'YScale',"log");
% set(gca,'YLim',[0 40]); 
set(gca,'XLim',[1 11]); 
set(gca,'XTick',[1:1:11]);
xlabel('SNR(dB)', 'FontSize', 15)
ylabel('WER', 'FontSize', 15)
% WERLOG = 10 * log10(WER+1)

% fprintf('Neer = %d, WER = %G, BER = %G\n', numberOfWorderrors, WER, BER);