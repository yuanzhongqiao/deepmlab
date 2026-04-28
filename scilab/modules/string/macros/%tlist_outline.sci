// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function s=%tlist_outline(x, verbose)
    tStr = " tlist";
    if type(x) == 17 then
        tStr = " mlist";
    end
    s = %type_dims_outline(x,typeStr = typeof(x)+tStr, brack=["(",")"]);
    if verbose == 1 then
        if fieldnames(x) <> [] then
            s = s + " with fields:";
        end
    end
endfunction
