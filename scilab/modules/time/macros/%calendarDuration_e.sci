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

function out = %calendarDuration_e(varargin)
    cd1 = varargin($);

    if nargin == 2 then
        if type(varargin(1)) == 1 && varargin(1) > size(cd1, "*") then
            error(msprintf(_("%s: Invalid index.\n"), "%calendarDuration_e"));
        end
    else
        if type(varargin(1)) == 1 && varargin(1) > size(cd1, "r") | type(varargin($-1)) == 1 && varargin($-1) > size(cd1, "c") then
            error(msprintf(_("%s: Invalid index.\n"), "%calendarDuration_e"));
        end
    end

    out_y = cd1.y(varargin(1:$-1));
    out_m = cd1.m(varargin(1:$-1));
    out_d = cd1.d(varargin(1:$-1));
    out_t = cd1.t(varargin(1:$-1));
    out = mlist(["calendarDuration", "y", "m" "d", "t", "format"], out_y, out_m, out_d, out_t, cd1.format);
endfunction
