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

function out = %timeseries_e(varargin)
    //disp(varargin)
    if type(varargin(1)) == 10 then
        i = varargin(1);
        ts = varargin(2);

        select i
        case "Properties"
            out = ts.props
        case "Variables"
            type_ref = -1;
            if 0 then
                type_ref = type(ts.vars(2).data);
                for i = 3:size(ts.vars, "*")
                    if type(ts.vars(i).data) <> type_ref then
                        type_ref = -1;
                        break;
                    end
                end
            end

            if type_ref == -1 | type_ref > 10 then //to cell
                out = [];
                for c = 2:size(ts.vars, "*")
                    v = num2cell(ts.vars(c).data)
                    out = [out, v];
                end
            else //to matrix of ref_type
                out = [];
                for i = 2:size(ts.vars, "*")
                    out = [out ts.vars(i).data];
                end
            end
        else
            [tmp, idx] = members(i, ts.props.variableNames);
            if idx <> [] then
                out = [];
                for i = idx
                    if out <> [] && typeof(out) <> typeof(ts.vars(i).data) then
                        error(msprintf(_("Different data types.\n")));
                    end
                    out = [out ts.vars(i).data];
                end
                //out = ts.vars(idx).data;
            else
                error(msprintf(_("Unknown field: %s"), i));
            end
        end
        return
    elseif type(varargin(1)) == 1 | type(varargin(1)) == 129 | type(varargin(1)) == 2 then
        ts = varargin($);
        if nargin == 2 then
            j = :;
        else
            j = varargin(2);
            if type(j) == 10 then
                str = ts.props.variableNames
                [xxx, j] = members(j, str);
                j = j - 1;
            end
        end

        i = varargin(1);

        if type(i) == 1 && or(i > size(ts, 1)) then
            error(msprintf(_("Extraction not possible.\n")));
        end
        out = ts;

        out.vars = [out.vars(1) out.vars(1, 2:$)(1, j)];

        for c = 1:size(out.vars, "*")
            out.vars(c).data = out.vars(c).data(i);
        end

    elseif type(varargin(1)) == 4 then
        idx = varargin(1);
        ts = varargin($);
        if nargin == 2 then
            j = :;
        else
            j = varargin(2);
            if type(j) == 10 then
                str = ts.props.variableNames
                [xxx, j] = members(j, str);
                j = j - 1;
            end
        end
        if size(idx, "*") == 1 then
            if idx == %t then
                out = ts(1, j);
            else
                out = [];
            end
        else //vector
            idx = find(idx);
            if idx == [] then
                out = [];
            else
                out = ts(idx, j);
            end
        end
    // elseif type(varargin(1)) == 2 then
    //     // t($, 1) ts($, $) ts($, "x1")
    //     idx = varargin(1)
    else //duration or datetime
        ts = varargin($);
        index = varargin(1);

        dura = ts.vars(1).data;
        if typeof(index) <> typeof(dura) then
            error(msprintf(_("Wrong extraction: index of type ""%s"" expected.\n"), typeof(dura)));
        end

        if isdatetime(index) then 
            d = dura.date * 24*60*60 + dura.time;
            nt = index.date * 24*60*60 + index.time;
        else
            d = dura.duration;
            nt = index.duration;
        end

        nb = members(d, nt);

        if nargin == 2 then
            j = :;
        else
            j = varargin(2);
            if type(j) == 10 then
                str = ts.props.variableNames
                [xxx, jdx] = members(j, str);
                if and(jdx == 0) then
                    error(msprintf(_("Unknown field: %s"), j));
                end
                j = jdx - 1;
            end
        end

        vindex = zeros(1, sum(nb));
        c = 1;
        for i = 1:length(index)
            idx = find(d == nt(i));
            vindex(1, c:(c-1)+length(idx)) = idx;
            c = c + length(idx)
        end

        out = ts(vindex, j);
    end

    if out == [] then
        return
    end

    //update props
    timeStep = %nan;
    sampleRate = %nan;
    time = out.vars(1).data;
    if size(time, "*") > 1 then
        [tmp, step] = isregular(time);
        if ~tmp then
            timeUnit = ["years", "months", "days"];
            for tu = timeUnit
                [tmp, step] = isregular(time, tu)
                if tmp then
                    break;
                end
            end
        end
        if ~isnan(step) then
            timeStep = step;
            if isduration(timeStep) then
                sampleRate = seconds(1) / timeStep;
            else
                sampleRate = %nan;
            end
            
        end
    end

    for f = fieldnames(out.props)'
        select f
        case "userdata"
            out.props(f) = [];
        case "startTime"
            out.props(f) = time(1);
        case "timeStep"
            out.props(f) = timeStep;
        case "sampleRate"
            out.props(f) = sampleRate;
        else
            if size(out.props(f), "*") == 1 then
                out.props(f) = [out.props(f)(1)];
            else
                out.props(f) = [out.props(f)(1) out.props(f)(2:$)(1, j)];
            end
        end
    end
endfunction
