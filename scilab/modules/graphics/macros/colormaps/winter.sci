// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Pierre MARECHAL <pierre.marechal@scilab.org>
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//winter colormap : Blue to green.
function cmap = winter(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    if n==0 then
        cmap = [];
        return
    end

    red    = zeros(n,1);
    green  = (0:n - 1)' / max(n-1,1);
    blue   = 0.5 + (1-green)/2;

    cmap = [red green blue];

endfunction
