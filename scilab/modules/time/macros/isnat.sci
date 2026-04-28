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

function out = isnat(dt)
    if nargin <> 1 then
        error(msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "isnat", 1));
    end
    if typeof(dt) <> "datetime" then
        if dt == [] then
            out = [];
        elseif ismatrix(dt) | isvector(dt) then
            out = zeros(dt) == 1;
        else
            out = %f;
        end
    else
        out = dt.date == -1;
    end
endfunction
