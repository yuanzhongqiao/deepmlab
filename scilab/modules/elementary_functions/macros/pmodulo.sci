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

function i = pmodulo(n, m)

    arguments
        n {mustBeA(n, ["double", "polynomial", "int"]), mustBeReal}
        m {mustBeA(m, ["double", "polynomial", "int"]), mustBeReal, mustBeEqualDimsOrScalar(m,n)}
    end

    nt = type(n);
    mt = type(m);
    if (nt == 8 | mt == 8) & nt <> mt then
        msg = _("%s: Incompatible input arguments #%d and #%d: Same types expected.\n")
        error(msprintf(msg, "pmodulo", 1, 2))
    end

    // --------------------------  Processing ------------------------

    if m==[]
        i = n;
        return;
    end
    if  nt== 2 then
        [i,_] = pdiv(n, m)
    else
        m = abs(m)  // else returns i<0 for m<0 : https://gitlab.com/scilab/scilab/-/issues/12373
        i = n - floor(n ./ m) .* m
        k = find(i<0)           // this may occur for encoded integers
        if k~=[]
            if length(m)>1 then
                i(k) = i(k) + m(k)
            else
                i(k) = i(k) + m
            end
        end
        if nt == 8 then
            i = iconvert(i, inttype(n))
        end
    end

endfunction
