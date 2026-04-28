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

function out = %timeseries_string(ts)
    [m,n] = size(ts);
    out = emptystr(m, n+1);

    for c = 1:n+1
        d = ts.vars(c).data;
        if type(d) <> 10 then
            d = string(d);
        end;
        out(:, c) = d;
    end
endfunction
