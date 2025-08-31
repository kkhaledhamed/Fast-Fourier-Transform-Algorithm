function T = FFT_types(dt)
switch dt
    case 'double'
        T.X   = complex(double([]));
        T.W   = complex(double([]));
        T.a   = complex(double([]));
        T.b   = complex(double([]));
        T.s1  = complex(double([]));  
        T.s2  = complex(double([]));  
        T.Y   = complex(double([]));

    case 'single'
        T.X   = complex(single([]));
        T.W   = complex(single([]));
        T.a   = complex(single([]));
        T.b   = complex(single([]));
        T.s1  = complex(single([]));  
        T.s2  = complex(single([]));
        T.Y   = complex(single([]));
        
     case 'FxPt' % Word Length = 12 bits
        T.X   = fi(complex(0,0), 1, 3 + 9, 9);    % Input: 3 int, 9 frac  
        T.W   = fi(complex(0,0), 1, 2 + 10, 10);  % Twiddle: 2 int, 10 frac 
        T.a   = fi(complex(0,0), 1, 4 + 8, 8);    % Butterfly input: 4 int, 8 frac 
        T.b   = fi(complex(0,0), 1, 4 + 8, 8);    % Butterfly input: 4 int, 8 frac 
        T.s1  = fi(complex(0,0), 1, 4 + 8, 8);    % First Stage output: 4 int, 8 frac 
        T.s2  = fi(complex(0,0), 1, 4 + 8, 8);    % Second Stage output: 4 int, 8 frac 
        T.Y   = fi(complex(0,0), 1, 5 + 7, 7);    % Output: 5 int, 7 frac 
end

end