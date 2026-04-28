// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function s = %type_dims_outline(x,typeStr,forceDims,brack)
    if ~isdef("typeStr","local")
        typeStr = typeof(x);
    end
    if ~isdef("forceDims","local")
        forceDims = %f;
    end
    if ~isdef("brack","local")
        brack = ["[","]"];
    end
    s = sprintf("%s%s%s",brack(1),typeStr,brack(2));
    //prevent error when x is tlist/mlist and has no size() overload
    try
        if forceDims || size(x,"*") > 1
            sizeStr = part(sprintf("%dx",size(x)'),1:$-1)
            s = sprintf("%s%s %s%s",brack(1),sizeStr,typeStr,brack(2));
        end
    catch
        lasterror();
    end
endfunction
