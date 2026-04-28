// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS

// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function x=cosm(a)
    //   cosm - computes the matrix cosine
    //%SYNTAX
    //   x=cosm(a)
    //%PARAMETERS
    //   a   : square hermitian or diagonalizable matrix
    //   x   : square hermitian matrix

    arguments
        a {mustBeA(a, "double")}
    end

    [m,n]=size(a);
    if m<>n then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: Square matrix expected.\n"),"cosm",1));
    end

    if a==[] then x=[],return,end

    if norm(imag(a),1)==0 then
        x=real(expm(%i*a))
    else
        x=0.5*(expm(%i*a)+expm(-%i*a));
    end

endfunction
