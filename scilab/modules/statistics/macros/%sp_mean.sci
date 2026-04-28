// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2020 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function y = %sp_mean(x, orient)
    
    // CHECK ARGUMENTS
    // ---------------
    // Number of inputs already checked in mean() that calls %sp_mean()
    // orient
    arguments
        x
        orient (1, 1) {mustBeA(orient, ["double", "string"]), mustBeMember(orient, {1, 2, "r", "c", "*", "m"})} = "*"
    end
    if orient == "m" then
        orient = find(size(x) > 1, 1);
        if orient == [] then
            orient = "*"
        end
    end

    // ----------
    // PROCESSING
    // ----------
    if isempty(x) then
        if orient=="*"
            y = mean([])
        else
            y = sparse(mean([], orient))
        end
        return
    end
    y = sum(x, orient) ./ size(x, orient)
endfunction
