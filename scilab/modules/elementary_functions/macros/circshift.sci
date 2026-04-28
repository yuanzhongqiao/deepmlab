// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function R = circshift(M, sh, d)

    arguments
        M
        sh double {mustBeA(sh, ["double", "int"]), mustBeInteger}
        d double {mustBeA(d, ["double", "int"]), mustBeInteger} = []
    end

    Fname = "circshift"

    s = size(M)
    n = size(M, "*")
    if or(n == [0, 1]) then
        R = M
        return
    end

    nd = length(s) ;   // Number of Dimensions (without using ndims())

    if length(sh) > nd then
        msg = _("%s: Argument #%d: Must be in the interval [%s, %s].\n");
        error(msprintf(msg, Fname, 2, "1", msprintf("%s\n", nd)));
    end

    if d == [] then
        if length(sh) == 1 then
            d = find(s > 1, 1)
            if d == [] then
                d = 1
            end
        else
            d = 1:length(sh)
        end
    else
        if (length(d) == 1 & (d < 0 | d > nd)) | (length(d) > 1 & or(d < 1 | d > nd)) then
            msg = _("%s: Argument #%d: Must be in the interval [%s, %s].\n");
            error(msprintf(msg, Fname, 3, "1", msprintf("%d\n", nd)));
        end
    end

    // PROCESSING
    // ----------
    R = M

    // Shift of linearized indices
    if length(d) == 1 & d == 0 then
        if sh > 0 then
            R(:) = M([n-sh+1:n 1:(n-sh)]);
        else
            R(:) = M([1-sh:n 1:-sh]);
        end
        return
    end

    // Shifts of ranges:
    for i = 1:length(sh)
        si = s(d(i));
        if si > 1 then
            D = pmodulo(sh(i), si)
            if D ~= 0 then
                S = emptystr(1, nd) + ":"
                S(d(i)) = "[si-D+1:si 1:si-D]"
                S = strcat(S, ",")
                execstr("R = R("+S+")")
            end
        end
    end
endfunction
