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

function t = cell2table(c, varargin)
    if typeof(c) <> "ce" then
        error(msprintf(_("%s: Wrong type for input argument #%d: a cell expected.\n"), "cell2table", 1));
    end

    l = list();
    s = [];
    for j = 1:size(c, 2)
        r = c{:, j};
        try
            l(j) = list2vec(r);
        catch
            error(msprintf(_("%s: Wrong type for c{:, %d}: same type by column expected.\n"), "cell2table", j));
        end
        s = [s size(l(j), "*")];
    end
    idx = find(s <> s(1));
    for j = idx
        l(j) = {l(j)};
    end

    t = table(l(:), varargin(:))
endfunction
