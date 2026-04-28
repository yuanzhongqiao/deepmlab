// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
// Copyright (C) DIGITEO - 2010 - Pierre Marechal
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2022 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function t = justify(t, job)

    // Check input parameters
    // =========================================================================

    rhs = argn(2);

    if rhs < 1 then
        error(msprintf(gettext("%s: Wrong number of input arguments: %d or %d expected.\n"),"justify",1, 2))
    end
    if t == [] then
        return;
    end
    if type(t) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"), "justify", 1));
    end

    if ~isdef("job","l") then
        job = "l"
    else
        if type(job) <> 10 then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"), "justify", 2));
        end
        if size(job,"*") <> 1 then
            error(msprintf(gettext("%s: Wrong size for input argument #%d: string expected.\n"), "justify", 2));
        end
        if and(job <> ["l" "c" "r" "left" "center" "right"]) then
            error(msprintf(gettext("%s: Wrong value for input argument #%d: ""%s"", ""%s"" or ""%s"" expected.\n"), "justify", 2,"r","l","c"));
            //  "left,center & right" are just here for backward compatibility
        end
    end

    // Hypermatrix
    // =========================================================================
    if  length(size(t)) > 2
        s = size(t)
        t = matrix(t, s(1), -1)
        t = justify(t, job)
        t = matrix(t, s)
        return
    end

    // Redefine the wanted justification
    // =========================================================================
    job = part(job, 1);

    // Remove leading and trailing whitespaces (See bug #7751)
    // =========================================================================
    t = stripblanks(t); // questionable

    // Justify character array.
    [m, n] = size(t);
    L = length(t);
    Lm = max(L, "r");
    if job == "l" then           //left
        for k = 1:n
            mx = Lm(k);
            t(:,k) = part(t(:,k),1:mx)
        end
    
    elseif job == "r" then       //right
        t = strrev(t)
        for k = 1:n
            mx = Lm(k);
            t(:,k) = part(t(:,k),1:mx)
        end
        t = strrev(t)

    elseif job == "c" then       //center
        st = size(t)
        L = length(t)
        mx = max(L,"r")
        paddN = ones(st(1),1)*mx - L
        [paddL, paddR] = ("","")
        paddNL = int(paddN/2); cs = cumsum(paddNL);
        if cs($) <> 0
            paddL = strsplit(blanks(cs($)+2),[1 ; 1+cs(:)])
            paddL([1 $]) = []
            paddL = matrix(paddL, st)
        end
        paddNR = paddN - paddNL;  cs = cumsum(paddNR);
        if cs($) <> 0
            paddR = strsplit(blanks(cs($)+2),[1 ; 1+cs(:)])
            paddR([1 $]) = []
            paddR = matrix(paddR, st)
        end
        t = paddL + t + paddR
    end
endfunction
