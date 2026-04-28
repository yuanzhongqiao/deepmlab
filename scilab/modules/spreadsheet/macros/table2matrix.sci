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

function mat = table2matrix(t)
    if ~istable(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: a table expected.\n"), "table2matrix", 1));
    end
    mat = t.vars(1).data;
    ref_type = typeof(mat);
    for j = 2:size(t, 2)
        d = t.vars(j).data;
        if ref_type <> typeof(d) then
            error(msprintf(_("Data must be the same type.\n")));
        end
        mat = [mat, d]
    end
endfunction
