// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = days(x)
    arguments
        x {mustBeA(x, ["double", "duration"]), mustBeReal}
    end

    if type(x) == 1 then
        if x == [] then
            out = duration([]);
        else
            out = duration(x * 24, 0, 0);
        end
    else
        // x is a duration
        out = x.duration / (24 * 60 * 60 * 1000);
    end
endfunction
