// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2022 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function x = %s_and(a, dim)
    // called for a = complex numbers
    // and(a)
    // and(a, dim)
    // for scalar matrices, an entry is TRUE if it is not zero.

    if argn(2)==1 then dim="*",end
    if dim=="*" then
        x = find(a==0,1)==[]
    else
        if a==[] then x=[],return,end
        x = sum(bool2s(abs(a)),dim)==size(a,dim)
    end
endfunction
