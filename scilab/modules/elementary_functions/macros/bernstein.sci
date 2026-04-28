// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function b = bernstein(n, t)
    arguments
        n (1,1) {mustBeA(n, "double"), mustBeInteger, mustBePositive}
        t {mustBeA(t, "double")}
    end

    if size(t, "*") == 1 then
        t = linspace(0, 1, t);
    end

    t1 = 1-t; 
    tt = t1;

    t1z = find(t1 == 0.0); 
    t1(t1z) = ones(t1z);

    a = t./t1;
    T = a' * ones(1, n);

    v = 1:n;
    D = ones(size(t, "c"), 1) *  ((n - v + 1) ./ v);
 
    b = [tt' .^ n, T .* D];

    b = cumprod(b, "c");

    // at least one 0 in t1
    if size(t1z, "c") > 0 then
        b(t1z, :) = ones(size(t1z, "c"), 1) * [zeros(1,n), 1];
    end

endfunction