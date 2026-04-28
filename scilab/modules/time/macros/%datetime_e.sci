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

function out = %datetime_e(varargin)
    select type(varargin(1))
    case 10
        idx = find(varargin(1) == ["Year", "Month", "Day", "Hour", "Minute", "Second"]);
        if idx == [] then
            error(msprintf(_("Unknown field: %s"), varargin(1)));
        end

        in = varargin($);
        out = zeros(in.date);

        if idx <= 3 then
            dv = datevec(in.date);
            out = matrix(dv(:, idx), size(in.date));
            // for i = 1:size(out, "*")
            //     dv = datevec(in.date(i));
            //     out(i) = dv(idx);
            // end

        else
            s = in.time;
            h = floor (s / 3600);
            s = s - 3600 * h;
            mi = floor (s / 60);
            s = s - 60 * mi;
            

            select idx
            case 4
                out = h;
            case 5
                out = mi;
            case 6
                out = s;
            end
        end

        out(find(in.date == -1)) = %nan;
    else //double, poly($), boolean, implicitlist (x:y)
        d = varargin($).date(varargin(1:$-1));
        t = varargin($).time(varargin(1:$-1));
        out = mlist(["datetime", "date", "time", "format"], d, t, varargin($).format);
    end
endfunction
