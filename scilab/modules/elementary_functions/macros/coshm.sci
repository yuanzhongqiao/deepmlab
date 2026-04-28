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

function x=coshm(x)
    // hyperbolic cosine of square matrix x

    arguments
        x {mustBeA(x, "double")}
    end

    [m, n] = size(x)
    if m <> n then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: A square matrix expected.\n"),"coshm",1));
    end

    if x <> [] then
        x=(expm(x)+expm(-x))/2;
    end

endfunction
