// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
// Copyright (C) 2012 - Scilab Enterprises - Cedric Delamarrre
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [dim,x]=unobs(A,C,tol)
    // n first columns of x span the unobservable
    // subspace of (A,C):
    //          dim
    //          [*,*]
    // X'*A*X = [0,*]
    //
    //    C*X = [0,*]
    // Copyright INRIA

    arguments
        A {mustBeA(A, "double"), mustBeReal}
        C {mustBeA(C, "double"), mustBeReal}
        tol (1,1) {mustBeA(tol, "double")} = 1.d-10*norm([A;C],1)
    end

    [p,p]=size(A);
    [n,w]=contr(A',C',tol);
    x=[w(:,n+1:p),w(:,1:n)];
    dim=p-n;
endfunction
