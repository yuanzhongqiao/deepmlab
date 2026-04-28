
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA - François DELEBECQUE
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [X,dim]=range(A,k)
    // Computation of Range A^k ; the first dim rows of X span the
    // range of A^k.
    //!
    arguments
        A {mustBeA(A, "double"), mustBeReal}
        k (1,1) double {mustBeA(k, ["double", "int"]), mustBeInteger, mustBeNonnegative} = 1
    end

    if k==0 then
        dim=size(A,1);X=eye(A);
    else
        [U,dim]=rowcomp(A);X=U;
        for l=2:k
            A=A*U';
            [U,dim]=rowcomp(A(:,1:dim));
            X=U*X;
        end;
    end
endfunction
