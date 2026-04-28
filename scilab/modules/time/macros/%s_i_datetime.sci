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

function out = %s_i_datetime(varargin)
    out = varargin($);

    if type(varargin(1)) == 10 then
        select varargin(1)
        case "Year"
            out = out - calyears(out.Year) + calyears(varargin($-1));
        case "Month"
            out = out - calmonths(out.Month) + calmonths(varargin($-1));
        case "Day"
            out = out - caldays(out.Day) + caldays(varargin($-1));
        case "Hour"
            out = out - hours(out.Hour) + hours(varargin($-1));
        case "Minute"
            out = out - minutes(out.Minute) + minutes(varargin($-1));
        case "Second"
            out = out - seconds(out.Second) + seconds(varargin($-1));
        end
    else
        if varargin($-1) == [] then
            out.date(varargin(1:$-2)) = varargin($-1);
            out.time(varargin(1:$-2)) = varargin($-1);
        end
    end
endfunction
