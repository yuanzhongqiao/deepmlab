// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2016, 2019 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function r = isinf(x)
    arguments
        x
    end

    if x==[] then
        r = []
    else
        select typeof(x)
        case "polynomial"
            // polynomials : https://gitlab.com/scilab/scilab/-/issues/10078
            r = matrix(or(isinf(coeff(x(:))),"c"), size(x))
        case "rational"
            msg = _("%s: Argument #%d: %s not supported.\n")
            error(msprintf(msg, "isinf", 1, "rationals"))
            // Possible implementation: a rational is inf if at least
            // one coefficient of its numerator is infinite
        else
            if isreal(x)
                r = abs(x)==%inf;
            else
                // workaround of https://gitlab.com/scilab/scilab/-/issues/14062
                r = abs(real(x))==%inf | abs(imag(x))==%inf
            end
        end
    end
endfunction
