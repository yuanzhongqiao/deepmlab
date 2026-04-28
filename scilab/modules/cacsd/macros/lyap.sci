// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function X = lyap(A,C,flag)
    //  solve  A'*X+X*A=C if flag=='c' or  A'*X*A-X=C if flag=='d'
    arguments
        A {mustBeA(A, "double"), mustBeReal, mustBeSquare}
        C {mustBeA(C, "double"), mustBeReal, mustBeSquare}
        flag {mustBeA(flag, "string"), mustBeMember(flag, ["c", "d"])}
    end

    if flag=="c" then
        flag=[0 0],
    elseif flag=="d" then
        flag=[1 0],
    end
    X=linmeq(2,A,C,flag)
endfunction
