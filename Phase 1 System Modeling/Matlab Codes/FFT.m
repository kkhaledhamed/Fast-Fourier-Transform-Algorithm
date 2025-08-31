function Y = FFT(X, T) 
N = 8;

% Twiddle factors 
W = cast([
    1.0000 + 0.0000i   % W^0
    0.7071 - 0.7071i   % W^1
    0.0000 - 1.0000i   % W^2
   -0.7071 - 0.7071i   % W^3
], 'like', T.W);

% Cast input
X = cast(X, 'like', T.X);

% Stage buffers (zero-based indexing in comments)
s1 = zeros(size(X), 'like', T.s1);
s2 = zeros(size(X), 'like', T.s2);
Y  = zeros(size(X), 'like', T.Y); % Final output

%% ===== Stage 1 (stride 4) =====
% Butterfly 0: X[0] & X[4] -> s1[0], s1[1] 
[s1(1), s1(2)] = butterfly(X(1), X(5), W(1), T);

% Butterfly 1: X[2] & X[6] -> s1[2], s1[3] 
[s1(3), s1(4)] = butterfly(X(3), X(7), W(1), T);

% Butterfly 2: X[1] & X[5] -> s1[4], s1[5] 
[s1(5), s1(6)] = butterfly(X(2), X(6), W(1), T);

% Butterfly 3: X[3] & X[7] -> s1[6], s1[7] 
[s1(7), s1(8)] = butterfly(X(4), X(8), W(1), T);


%% ===== Stage 2 (stride 2)  =====
% Butterfly 0: s1[0] & s1[2] -> s2[0], s2[2] 
[s2(1), s2(3)] = butterfly(s1(1), s1(3), W(1), T);

% Butterfly 1: s1[1] & s1[3] -> s2[1], s2[3] 
[s2(2), s2(4)] = butterfly(s1(2), s1(4), W(3), T); % W^2

% Butterfly 2: s1[4] & s1[6] -> s2[4], s2[6] 
[s2(5), s2(7)] = butterfly(s1(5), s1(7), W(1), T);

% Butterfly 3: s1[5] & s1[7] -> s2[5], s2[7] 
[s2(6), s2(8)] = butterfly(s1(6), s1(8), W(3), T); % W^2

%% ===== Stage 3 (stride 1) =====
% Butterfly 0: s2[0] & s2[4] -> Y[0], Y[4] 
[Y(1), Y(5)] = butterfly(s2(1), s2(5), W(1), T);

% Butterfly 1: s2[1] & s2[5] -> Y[1], Y[5] 
[Y(2), Y(6)] = butterfly(s2(2), s2(6), W(2), T); % W^1

% Butterfly 2: s2[2] & s2[6] -> Y[2], Y[6] 
[Y(3), Y(7)] = butterfly(s2(3), s2(7), W(3), T); % W^2

% Butterfly 3: s2[3] & s2[7] -> Y[3], Y[7] 
[Y(4), Y(8)] = butterfly(s2(4), s2(8), W(4), T); % W^3
%% ===== Printing Stages =====
fprintf("Stage 1\n");
for i = 1:8
    disp(s1(i));
end
fprintf("\n\n");

fprintf("Stage 2\n");
for i = 1:8
    disp(s2(i));
end
fprintf("\n\n");

fprintf("Stage 3\n");
for i = 1:8
    disp(Y(i));
end
fprintf("\n\n");
end
