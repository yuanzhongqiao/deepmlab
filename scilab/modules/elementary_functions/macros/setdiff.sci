// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) DIGITEO - 2011 - Allan CORNET
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2018 - 2020 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [a, ka] = setdiff(a, b, orien)
    // returns a values which are not in b

    // History:
    // * 2018 - S. Gougeon : orien="r"|"c" added, including the hypermat case
    // * 2019 - S. Gougeon : complex numbers supported

    arguments
        a {mustBeA(a, ["double", "boolean", "sparse", "booleansparse", "int", "string", "duration", "datetime", "table", "timeseries"])}
        b {mustBeA(b, ["double", "boolean", "sparse", "booleansparse", "int", "string", "duration", "datetime", "table", "timeseries"])}
        orien {mustBeA(orien, ["double", "string"]), mustBeMember(orien, {1, 2, "r", "c", "*"})}= "*"
    end

    ka = [];
    if size(a, "*") == 0 then
        return
    end
    
    typa = type(a)

    if or(typa == [1 4 5 6 8 10]) then

        if typa == 10 & size(b, "*") <> 0 & type(b) <> 10 then
            msg = _("%s: Wrong type for input argument #%d: Must be same type of #%d.\n")
            error(msprintf(msg, "setdiff", 2, 1))
        end
        if typa == 8 & type(b) == 8 & inttype(a) <> inttype(b) then
            msg = _("%s: Wrong type for input arguments #%d and #%d: Same integer types expected.\n")
            error(msprintf(msg, "setdiff", 1, 2))
        end
        // orien
        if orien == "*" then
            orien = 0
        elseif orien == "r" then
            orien = 1
        elseif orien == "c" then
            orien = 2
        end

        if orien==1 & size(b,"*")<>0 & size(a,2)~=size(b,2) then
            msg = _("%s: Wrong size for input arguments #%d and #%d: Same numbers of columns expected.\n")
            error(msprintf(msg, "setdiff", 1, 2))
        end
        if orien==2 & size(b,"*")<>0 &  size(a,1)~=size(b,1) then
            msg = _("%s: Wrong size for input arguments #%d and #%d: Same numbers of rows expected.\n")
            error(msprintf(msg, "setdiff", 1, 2))
        end

        // ==========
        // PROCESSING
        // ==========
        Complexes = (or(typa   ==[1 5]) && ~isreal(a)) | ..
                    (or(type(b)==[1 5]) && ~isreal(b));

        // "r" or "c"
        // ==========
        if orien then
            if ndims(a) > 2 then
                a = serialize_hypermat(a, orien)
            end
            if ndims(b) > 2 then
                b = serialize_hypermat(b, orien)
            end
            if nargout > 1
                [a, ka] = unique(a, orien)
            else
                a = unique(a, orien)
            end
            if size(b,"*")==0
                return
            end
            b = unique(b, orien)
            if orien==2
                a = a.'
                b = b.'
            end
            if Complexes
                [c, kc] = gsort([a ; b], "lr", ["i" "i"], list(abs, atan))
            else
                [c, kc] = gsort([a ; b], "lr", "i")
            end
            k = find(and(c(1:$-1,:) == c(2:$,:), "c"))
            if k <> []
                a(kc([k k+1]),:) = []
                if nargout > 1
                    ka(kc([k k+1])) = []
                end
            end
            if orien==2
                ka = matrix(ka, 1, -1)
                a = a.'
            end

        else
            // by element
            // ==========
            if nargout > 1
                [a, ka] = unique(a);
            else
                a = unique(a);
            end
            if size(b,"*")==0
                return
            end
            b = unique(b(:));
            if Complexes
                [x, k] = gsort([a(:) ; b], "g", ["i" "i"], list(abs, atan));
            else
                [x, k] = gsort([a(:) ; b], "g", "i");
            end
            e = find(x(2:$)==x(1:$-1));
            if e <> []
                a(k([e e+1])) = []
                if nargout > 1
                    ka(k([e e+1])) = []
                end
            end
        end
    else
        typA = typeof(a);
        typB = typeof(b);
        if typA <> typB then
            error(msprintf(_("%s: Wrong type for input argument #%d: Must be same type of #%d.\n"), "setdiff", 2, 1));
        end
        if orien == "*" then
            execstr("[a, ka] = %" + typA + "_setdiff(a, b)");
        else
            if or(typA == ["table", "timeseries"]) then
                warning(msprintf(_("%s: orient option is not supported for table and timeseries objects.\n"), "setdiff"));
                execstr("[a, ka] = %" + typA + "_setdiff(a, b)");
            else
                execstr("[a, ka] = %" + typA + "_setdiff(a, b, orien)");
            end
        end
    end
endfunction

// ----------------------------------------------------------------------------

function h = serialize_hypermat(h, orien)
    if orien==1 then
        dims = 1:ndims(h)
        dims([1 2]) = [2 1]
        h = permute(h, dims)
        h = matrix(h, size(h,1), -1).'
    else
        h = matrix(h, size(h,1), -1)
    end
endfunction
