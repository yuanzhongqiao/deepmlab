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

function varargout = isregular(varargin)
    [_a, fname] = where();
    fname = fname(1);

    if nargin == 0 || nargin > 2 then
        error(msprintf(_("%s: Wrong number of input argument: %d to %d expected.\n"), fname, 1, 2));
    end

    out = %f;
    timeUnit = "time";
    in = varargin(1);

    if and(typeof(in) <> ["duration", "datetime", "timeseries"]) then
        error(msprintf(_("%s: Wrong type for input argument #%d: duration, datetime or timeseries expected.\n"), fname, 1));
    end

    if nargin == 2 then
        if type(varargin(2)) <> 10 then
            error(msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), fname, 2));
        end
        timeUnit = varargin(2);
        if and(timeUnit <> ["years", "months", "days", "time"]) then
            error(msprintf(_("%s: Wrong value for input argument #%d: {""%s"", ""%s"", ""%s"", ""%s""} expected.\n"), fname, 2, "years", "months", "days", "time"));
        end
    end

    if typeof(in) == "timeseries" then
        in = in.vars(1).data;
    end

    step = %nan;
    if or(timeUnit == ["years", "months", "days"]) then
        if isdatetime(in) then
            dt1 = datevec(in(1).date);
            dt2 = datevec(in(2).date);
            diffD = dt2 - dt1;
            select timeUnit
            case "years"
                step = calyears(diffD(1));
            case "months"
                step = calmonths(diffD(2));
            case "days"
                step = caldays(diffD(3));
            end
        end
    else
        diffD = in(2:$) - in(1:$-1);
        step = diffD(1);
    end
    if ~isnan(step) then
        t = in(1):step:in($);
        if iscolumn(in) then
            t = t';
        end
        out = and(t == in);
    end

    varargout(1) = out;
    if nargout == 2 then
        if out then
            varargout(2) = step;
        else
            varargout(2) = %nan;
        end
    end
    
endfunction
