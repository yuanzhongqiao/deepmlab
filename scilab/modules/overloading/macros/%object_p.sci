// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function %object_p(s)
    str = %object_string(s);
    if ~isempty(str)
        mprintf("  %s\n", str);
    end
endfunction
