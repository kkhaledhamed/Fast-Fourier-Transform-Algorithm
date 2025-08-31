clc; clear; close all;

%% ===== Create data types table =====
data_type='double';% double, single or FxPt
T = FFT_types(data_type);

% Twiddle factors
W = cast([
    1.0000 + 0.0000i   % W0
    0.7071 - 0.7071i   % W1
    0.0000 - 1.0000i   % W2
    -0.7071 - 0.7071i   % W3
    ], 'like', T.W);

%% ===== Design Parameters =====
N = 8;                     % FFT number of points
nSeeds = 100;              % Number of random trials
error  = zeros(1, nSeeds); % Store error for each trial
sqnr   = zeros(1, nSeeds); % Store SQNR per trial

fid_in   = fopen('FFT_inputs.txt', 'w');
fid_out  = fopen('FFT_outputs.txt', 'w');
fid_in_real   = fopen('FFT_inputs_real.txt', 'w');
fid_in_imag   = fopen('FFT_inputs_imag.txt', 'w');
fid_out_real   = fopen('FFT_outputs_real.txt', 'w');
fid_out_imag   = fopen('FFT_outputs_imag.txt', 'w');

%% ===== Testing FFT Algorithm =====
for seed = 1:nSeeds
    rng(seed);
    
    % ===== Generate random complex test input signal =====
    x1= randn(1,N) + 1j*randn(1,N);
    X = cast(x1, 'like', T.X);
    
    for k = 1:length(X)
        fprintf(fid_in, '%s %s ', hex(fi(real(X(k)))), hex(fi(imag(X(k)))));
        fprintf(fid_in_real, '%s ', bin(fi(real(X(k)))));
        fprintf(fid_in_imag, '%s ', bin(fi(imag(X(k)))));
    end
    
    % ===== First iteration: build instrumented MEX =====
    if seed == 1
        buildInstrumentedMex FFT -args {X, T};
    end
    
    % ===== Call FFT algorithm =====
    Y = FFT_mex(X, T);
    
    % ===== Verify results =====
    Y_Expected = fft(x1);
    error(seed) = abs(mean(double(Y) - Y_Expected));
    
    
    % === SQNR calculation ===
    signal_power = sum(abs(Y_Expected).^2);
    noise_power  = sum(abs(double(Y) - Y_Expected).^2);
    sqnr(seed)   = 10*log10(signal_power / noise_power);
    
    % Round outputs to match fixed-point
    Y_round = cast(round(Y), 'like', T.Y);
    Y_Expected_round = round(Y_Expected);
    
    for k = 1:length(Y)
        fprintf(fid_out, '%s %s ', bin(fi(real(Y(k)))), bin(fi(imag(Y(k)))));
        fprintf(fid_out_real, '%s ', bin(fi(real(Y(k)))));
        fprintf(fid_out_imag, '%s ', bin(fi(imag(Y(k)))));
    end
    
    % Add newlines for each seed
    fprintf(fid_in,      '\n');
    fprintf(fid_in_real, '\n');
    fprintf(fid_in_imag, '\n');
    fprintf(fid_out,     '\n');
    fprintf(fid_out_real,'\n');
    fprintf(fid_out_imag,'\n');
end

fclose(fid_in);
fclose(fid_in_real);
fclose(fid_in_imag);
fclose(fid_out);
fclose(fid_out_real);
fclose(fid_out_imag);

%% ===== Compute Average SQNR =====
avg_sqnr = mean(sqnr); 

%% ===== PLOT RESULTS =====
figure;
subplot(2,1,1);
plot(1:nSeeds, error, 'LineWidth', 2); grid on;
xlabel('Seed', 'FontSize', 12); ylabel('Error', 'FontSize', 12);
title(sprintf('Radix-2 FFT %d Points and %s Data Type \n Error per seed', N, data_type), 'FontSize', 14);

subplot(2,1,2);
plot(1:nSeeds, sqnr, 'LineWidth', 2); grid on;
xlabel('Seed', 'FontSize', 12); ylabel('SQNR (dB)', 'FontSize', 12);
title(sprintf('SQNR per seed, Average = %.3f dB', avg_sqnr), 'FontSize', 14);

%% ===== Show instrumentation results =====
showInstrumentationResults FFT_mex -proposeFL -defaultDT numerictype(1, 32)
