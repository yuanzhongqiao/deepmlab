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

function c = table2cell(t)
    if ~istable(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: a table expected.\n"), "table2cell", 1));
    end

    [row, col] = size(t);
    c = cell(row, col);
    for j = 1:col
        tb = t.vars(j).data;
        for i = 1:row
            c{i,j} = tb(i);
        end
    end
endfunction
