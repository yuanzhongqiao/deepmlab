// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function x=diff(x,N,DIM)
    arguments
        x {mustBeA(x, ["double", "polynomial", "int", "sparse"])}
        N (1,1) {mustBeA(N, "double"), mustBePositive} = 1
        DIM (1,1) {mustBeA(DIM, ["double", "string"])} = "*"
    end
    
    dims=size(x),nd=prod(size(dims))
    if DIM=="r" then DIM=1,end
    if DIM=="c" then DIM=2,end
    if DIM=="*" then DIM=-1,end
    DIM=round(DIM)
    if DIM<>-1&DIM<1 then
        error(msprintf(gettext("%s: Wrong values for input argument #%d: Non-negative integers expected.\n"),"diff",3));
    end
    if DIM>nd then x=[],return,end

    N=round(N)

    if N==1 then
        if (DIM==-1) then
            if prod(dims)>1
                x=x(2:$)-x(1:$-1);
            else
                x = [];
            end
        else
            args=emptystr(1,nd)+":"
            arg1=args;arg1(DIM)="2:$";
            arg2=args;arg2(DIM)="1:$-1";
            execstr("x=x("+strcat(arg1,",")+")-x("+strcat(arg2,",")+")")
        end
    else
        for i=1:N, x=diff(x,1,DIM),end
    end
endfunction
