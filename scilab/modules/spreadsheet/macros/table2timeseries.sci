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

function ts = table2timeseries(varargin)
    data = varargin(1)
    fname = "table2timeseries";

    if ~istable(data) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A table expected.\n"), fname, 1));
    end
    
    names = data.Properties.VariableNames;
    hasrowtimes = %f;
    timeindex = [];
    rhs = nargin;
    opts = list();
    

    if rhs > 1 then
        for i = nargin-1:-2:2
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end

            select varargin(i)
            case "RowTimes"
                rowTimes = varargin(i+1);
                if and(typeof(rowTimes) <> ["string", "duration", "datetime"]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: variable name or duration or datetime vector expected.\n"), fname, i+1));
                end
                if or(typeof(rowTimes) == ["duration", "datetime"]) then
                    s = size(rowTimes);
                    if s(1) <> size(data, 1) then
                        error(msprintf(_("%s: Wrong size for input argument #%d: must have the same number of rows as the table.\n"), fname, i+1));
                    end
                    opts($+1) = varargin(i);
                    opts($+1) = varargin(i+1);

                elseif type(rowTimes) == 10 then
                    [tmp, idx] = members(rowTimes, names);
                    if idx == 0 then
                        error(msprintf(_("%s: Wrong value of input argument #%d: a valid variable name expected.\n"), fname, i+1));
                    end
                    if and(typeof(data(rowTimes)) <> ["duration", "datetime"]) then
                        error(msprintf(_("%s: duration or datetime vector expected.\n"), fname));
                    end
                    timeindex = idx;
                    timeData = data(rowTimes);
                end
                hasrowtimes = %t;
            else
                opts($+1) = varargin(i);
                opts($+1) = varargin(i+1);
            end
            
            rhs = rhs - 2;
        end
    end

    l = list();
    
    if ~hasrowtimes & timeindex == [] then
        for i = 1:size(data, 2);
            d = data.vars(i).data;
            if timeindex == [] && or(isduration(d) || isdatetime(d)) then
                timeindex = i;
                timeData = d;
            end
            l(i) = d;
        end
    else
        l = data.vars.data;
    end

    if timeindex <> [] then
        l(timeindex) = null();
        varNames = names(timeindex);
        names(timeindex) = [];
        varNames = [varNames names];
        val = list(timeData, l(:));
    else
        idx = grep(names, "Time");
        if idx == [] then
            varNames = ["Time", names];
        else
            n = names(idx);
            pos = ["" emptystr(n)]
            pos(2:$) = "_" + string(1:length(idx))
            r = strsubst(n, "Time", "");
            nb = members(pos, r);
            varNames = ["Time" + pos(nb==0)(1), names];
        end

        val = l;
    end

    ts = timeseries(val(:), opts(:), "VariableNames", varNames);
endfunction
