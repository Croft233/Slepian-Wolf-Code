clc
clear all

p = 0.1;
Nstop = 100000;

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

numberOfBitErrors = 0;
numberOfWorderrors = 0;
Nframes = 0;

while Nframes < Nstop
    u = randi([0 1], 1, k);
    c = mod(u * G, 2);

    e = rand(1,n) < p;
    y = mod(c+e, 2);

    s = mod(y * H', 2);
    ss = bi2de(s)+1;
    ehat = Phi(ss,:);

    chat = mod(y - ehat, 2);

    nbe = sum(mod(c -chat,2));
    numberOfBitErrors = numberOfBitErrors +nbe;
    numberOfWorderrors = numberOfWorderrors + (nbe > 0);
    Nframes = Nframes + 1;

end

WER = numberOfWorderrors
BER = numberOfBitErrors

fprintf('Neer = %d, WER = %G, BER = %G\n', numberOfWorderrors, WER, BER);