// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) DIGITEO - 2011 - Allan CORNET
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
// Copyright (C) 2013, 2018 - Samuel GOUGEON
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function i = modulo(n, m)

    arguments
        n {mustBeA(n, ["double", "polynomial", "int"]), mustBeReal}
        m {mustBeA(m, ["double", "polynomial", "int"]), mustBeReal, mustBeEqualDimsOrScalar(m, n)}
    end

    nt = type(n);
    mt = type(m);
    if (nt == 8 | mt == 8) & nt ~= mt then
        msg = _("%s: Incompatible input arguments #%d and #%d: Same types expected.\n")
        error(msprintf(msg, "modulo", 1, 2))
    end

    // --------------------------  Processing ----------------------------

    if m == [] then
        i = n;
        return
    end
    if or(nt == [1 8]) then
        i = n - int(n ./ m) .* m
        if nt == 8 then
            i = iconvert(i, inttype(n))
        end
    else
        [i,_] = pdiv(n, m)
    end

endfunction
