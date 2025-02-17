clc
clear all;

% For an SW code C, select the systematic (n,k)=(7,4)
G = [
    1 0 0 0 1 0 1;
    0 1 0 0 1 1 0;
    0 0 1 0 1 1 1;
    0 0 0 1 0 1 1];         
I = G(:,1:4);
P = G(:,5:7);
H = [P' eye(3)];
[k, n] = size(G);

for i = 0:(2^k)-1               %codewords generation
    codewords = de2bi(i, k);
    iCode = mod((codewords * G), 2);
    codebook(i+1,:) = iCode;
end

%{
Splitting G into 2 generator matrices, G1 that contains the first m = 2
rows of G , and G2 that contains the last 2 rows. X is coded using C1 and Y
using C2. Let P' = [P1' P2']. Then for the (n-m)*n parity-check matrices,
H1 and H2, of C1 and C2.
%}
G1 = G(1:2, :);
G2 = G(3:4, :);

P1 = P(1:2,:);
P2 = P(3:4,:);

H1 = [zeros(2) P1]; 
H1 = H1';
H1 = [H1 eye(5)];

P22 =  P2';
H2 = [eye(2) zeros(2) zeros(2,3); zeros(3,2) P22 eye(3)];
clear P22;

% Source code x and y
x = [0 0 1 0 1 1 0];
y = [0 1 1 0 1 1 0];

a1 = x(:,1:2);
v1 = x(:,3:4);
q1 = x(:,5:7);

u2 = y(:,1:2);
a2 = y(:,3:4);
q2 = y(:,5:7);

%Encoder
s1 = mod( (H1 * x')', 2);
s2 = mod( (H2 * y')', 2);

%Decoder
% t1 = mod( (P1' *a1'), 2);
% t1 = [zeros(2,1); v1'; bitxor(t1, q1')];
% t1 = t1';
% 
% t2 = mod( (P2' *a2'), 2);
% t2 = [u2'; zeros(2,1); bitxor(t2, q2')];
% t2 = t2';
% t1 = [zeros(2,1) v1 ];

t1 = [zeros(2,1); s1']';
t2 = [s2(:,1:2)'; zeros(2,1); s2(:,3:5)']';
Sumt = t1+t2;
Dinform = 2;
for i = 1:2^k
    c = codebook(i,:);
    Dec = sum(mod(c-Sumt, 2));
    if Dinform > Dec
        chat = c;
        Dbest = Dec;
    end
end

a1hat = chat(:,1:2);
a2hat = chat(:,3:4);
xhat = mod(a1hat*G1,2);
xhat = mod(xhat+t1,2)
yhat = mod(a2hat*G2,2);
yhat = mod(yhat+t2,2)

% xhat = a1hat * G1;
% xhat = bitxor(xhat, t1);
% yhat =  a2hat * G2;
% yhat =  bitxor(yhat, t2);
% 
% Codeword = xhat + yhat + t1 + t2;
% Codeword = mod(Codeword, 2);
