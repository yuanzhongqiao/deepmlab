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

function out = %s_m_calendarDuration(coef, cd1)
    if size(cd1, "*") <> 1 && size(coef, "*") <> 1 && or(size(coef) <> [size(cd1, 'c') size(cd1, 'r')]) then
        error(msprintf(_("%s: Inconsistent row/column dimensions.\n"), "%s_m_calendarDuration"));
    end
    
    out = cd1 * coef;
endfunction
