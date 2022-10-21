%% Using audio file from lab.

[y,fs] = audioread('speech.wav');

% create a single frame of speech.
hwin = hamming(512);
frame = hwin .* y(1001:1512);
yf = fft(frame);
magSpec_sym = abs(yf);
magSpec = magSpec_sym(1:256);

% plot(magSpec);

%% Create a filterbank -  Make 20 filters, triangles, MEL-spaced. 

% n filters
n = 20; 
% k frequency coefficients
k = 256;

% Inline conversion functions
f2m = @(x) 2595 .* log10(1 + (x./700));
m2f = @(x) 700 .* (10 .^ (x./2595) - 1);

% the frequency range of the magspec frame
lowHz = 0;
hiHz = fs/2;

% convert the freq in Hz to MEL.
lowMel = f2m(lowHz);
hiMel = f2m(hiHz);

% now in mel scale, create n spaced scale (+ 2 for the last mid and end point).
x_mel = linspace(lowMel, hiMel, n + 2);
x_hz = m2f(x_mel);

% we could view the scale spacing
% plot(x_hz, ones(n+2), 'o');

%% set up the filterbank

fbank = zeros(n, k);
bin = floor(1 + k * x_hz / hiHz);
bin(n + 2) = k;

for j = 1:n
    % set the up slope.
    for i = bin(j):bin(j+1)
         fbank(j, i) = (i - bin(j)) / (bin(j+1)-bin(j));
    end
    % set the down slope.
    for i = bin(j+1):bin(j+2)
         fbank(j, i) = (bin(j+2) - i) / (bin(j+2)-bin(j+1));
    end
end

%% Plot the filter banks

figure;
for j = 1:n
plot(fbank(j, :));
title('N Triangle Filters')
hold on;
end
hold off;

%% Apply the filterbank

filtered = fbank * magSpec;
figure;
plot(filtered);
title('Filter applied to MagSpec')

%% Test the function

tri15 = trianglefbank(15, k, lowHz, hiHz);

figure;
for j = 1:15
plot(tri15(j, :));
title('15 filters')
hold on;
end
hold off;
