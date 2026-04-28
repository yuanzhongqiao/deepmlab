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

function out = %calendarDuration_i_calendarDuration(varargin)
    out = varargin($);
    if nargin == 3 then
        if type(varargin(1)) == 1 && or(varargin(1) < 0) then
            error(msprintf(_("%s: Invalid index.\n"), "%calendarDuration_i_calendarDuration"));
        end
    else
        if type(varargin(1)) == 1 && or(varargin(1) < 0) | type(varargin(2)) == 1 && or(varargin(2) < 0) then
            error(msprintf(_("%s: Invalid index.\n"), "%calendarDuration_i_calendarDuration"));
        end
    end

    out.y(varargin(1:$-2)) = varargin($-1).y;
    out.m(varargin(1:$-2)) = varargin($-1).m;
    out.d(varargin(1:$-2)) = varargin($-1).d;
    out.t(varargin(1:$-2)) = varargin($-1).t;
endfunction
