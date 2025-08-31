function [y0, y1] = butterfly(a, b, W, T)
    a = cast(a, 'like', T.a);
    b = cast(b, 'like', T.b) * W;
    y0 = a + b;
    y1 = a - b;
end