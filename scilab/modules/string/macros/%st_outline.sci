// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function s=%st_outline(x, verbose)
    s = %type_dims_outline(x,typeStr="struct",forceDims=size(x,"*")~=1);
    if verbose == 1 then
        if fieldnames(x) == [] then
            s = s + " with no field";
        else
            s = s + " with fields:";
        end
    end
endfunction
