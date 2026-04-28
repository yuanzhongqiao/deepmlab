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

function out = %calendarDuration_i_s(varargin)
    //do it with double matrix to get final size
    cal = varargin($-1);
    a = [];
    [r, c] = size(cal);
    x = ones(r, c);
    a(varargin(1:$-2)) = x;
    out = calendarDuration(0, 0, zeros(x));
    out(a <> 0) = cal;
    out.format = cal.format;
endfunction
