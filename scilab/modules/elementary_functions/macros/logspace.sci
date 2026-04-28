// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function y = logspace(d1, d2, n)
    // Geometrical series of numbers in [10^d1, 10^d2].
    // logspace(d1,d2) generates a row vector of 50 logarithmically
    // equally spaced values between 10^d1 and 10^d2.
    // If d2=%pi, then the points are between 10^d1 and pi.
    // logspace(d1, d2, n) generates n values.

    arguments
        d1 (:, 1)
        d2 {mustBeEqualDims(d2, d1)}
        n (1,1) {mustBeA(n, "double"), mustBeInteger} = 50
    end

    if d2==%pi then
        d2 = log10(%pi);
    end
    if n>1
        y = 10 .^( d1*ones(1,n) + [(d2-d1)*(0:n-2)/(floor(n)-1),d2-d1]);
    elseif n==1
        y = 10.^d2
    else
        y = []
    end
endfunction
