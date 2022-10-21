function [fbank] = trianglefbank(n, k, loHz, hiHz)
%TRIANGLEFBANK return a filterbank
%   n filters, k frequency coefficients
%   loHz: minimum frequency (usually zero)
%   hiHz: maximum frequency of magspec (e.g. 8000 for fs=16000)

% Inline conversion functions
f2m = @(x) 2595 .* log10(1 + (x./700));
m2f = @(x) 700 .* (10 .^ (x./2595) - 1);

% convert the freq in Hz to MEL.
lowMel = f2m(loHz);
hiMel = f2m(hiHz);

x_mel = linspace(lowMel, hiMel, n + 2);
x_hz = m2f(x_mel);

fbank = zeros(n, k);
bin = floor(1 + k * x_hz / hiHz);
bin(n + 2) = k;

for j = 1:n
    for i = bin(j):bin(j+1)
         fbank(j, i) = (i - bin(j)) / (bin(j+1)-bin(j));
    end
    for i = bin(j+1):bin(j+2)
         fbank(j, i) = (bin(j+2) - i) / (bin(j+2)-bin(j+1));
    end
end

end

