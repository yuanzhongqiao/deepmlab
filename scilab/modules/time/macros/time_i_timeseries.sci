// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = time_i_timeseries(i, val, ts)
    out = ts;
    select i
    case "StartTime"
    case "TimeStep"
    case "Properties"
    case "SampleRate"
    else
        idx = find(ts.props.variableNames == i);
        if and(size(val) > [1 1]) then
            error(msprintf(_("%s: Wrong size for input argument #%d: Must be a vector.\n"), "%datetime_i_timeseries", 2));
        end
        val = val(:);
        if idx == [] then
            varnames = [out.props.variableNames(1) i];
            out = [out timeseries(out.vars(1).data, val, "VariableNames", varnames)]
        else
            out.vars(idx).data = val;
        end

        if idx == 1 then
            // modified "Time" variable (first column of a timeseries)
            props = out.Properties;

            [tmp, step] = isregular(val);
            if ~tmp then
                timeUnit = ["years", "months", "days"];
                for tu = timeUnit
                    [tmp, step] = isregular(val, tu)
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
                props.timeStep = timeStep;
                props.sampleRate = sampleRate;
            end
            props.startTime = val(1);
            out.props = props;
        end
    end
endfunction