// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2019 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function t = coth(x)
    //Syntax : t=coth(x)
    //
    // hyperbolic co-tangent of x

    arguments
        x {mustBeA(x, ["double", "sparse"])}
    end
    
    // ( coth(0) => +/- Inf ) => (sparse => full)
    t = 1 ./ tanh(full(x))
endfunction
