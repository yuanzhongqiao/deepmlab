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

function out = %props_i_timeseries(varargin)
    // disp("_i_2");
    out = varargin($);
    p = varargin(2);
    //disp(out, p)

    if out.props.startTime <> p.startTime then
        if and(typeof(p.startTime) <> ["datetime", "duration"]) then
            error(msprintf(_("%s: Wrong type for %s property: %s or %s expected.\n"), "timeseries", "StartTime", "datetime","duration"));
        end

        if size(p.startTime, "*") <> 1 then
            error(msprintf(_("%s: Wrong size for %s property: scalar expected.\n"), "timeseries", "StartTime"));
        end

        diff_t = out.vars(1).data(2:$) - out.vars(1).data(1:$-1);
        abso = abs(diff_t.duration);
        cs = cumsum(abso);
        tmp = [p.startTime ; p.startTime + milliseconds(cs)];

        out.vars(1).data = [];
        out.vars(1).data = tmp;

        if out.vars(1).data.format == [] then
            if typeof(out.vars(1).data) == "datetime" then
                if or(out.vars(1).data.time <> 0) then
                    out.vars(1).data.format = "yyyy-MM-dd HH:mm:ss";
                end
            end
        end
    // elseif (~isnan(out.props.sampleRate) || ~isnan(p.sampleRate)) || (~isnan(out.props.sampleRate) && ~isnan(p.sampleRate) && out.props.sampleRate <> p.sampleRate) then
    elseif (~isnan(out.props.sampleRate) || ~isnan(p.sampleRate)) || (~isnan(out.props.sampleRate) && ~isnan(p.sampleRate) && out.props.sampleRate <> p.sampleRate) then
        if typeof(p.sampleRate) <> typeof(out.props.sampleRate) then
            error(msprintf(_("%s: Wrong type for %s property: double expected.\n"), "timeseries", "SampleRate"));
        end

        if size(p.sampleRate, "*") <> 1 then
            error(msprintf(_("%s: Wrong size for %s property: scalar expected.\n"), "timeseries", "SampleRate"));
        end

        if ~isnan(p.sampleRate) && isduration(p.timeStep) then
            step = duration(0, 0, 1 / p.sampleRate, "OutputFormat", p.timeStep.format);
            timeStep = step;
            startTime = out.vars(1).data(1);
            r = size(out.vars(1).data, 1);
            out.vars(1).data = (startTime:step:startTime + step * (r - 1))';
            p.timeStep = timeStep;
        else
            timeStep = p.timeStep;
            startTime = out.vars(1).data(1);
            r = size(out.vars(1).data, 1);
            out.vars(1).data = (startTime:timeStep:startTime + timeStep * (r - 1))';
        end

    elseif (~isnan(out.props.timeStep) || ~isnan(p.timeStep)) || (~isnan(out.props.timeStep) && ~isnan(p.timeStep) && out.props.timeStep <> p.timeStep) then
        if and(typeof(p.timeStep) <> ["calendarDuration", "duration"]) then
            error(msprintf(_("%s: Wrong type for %s property: %s or %s expected.\n"), "timeseries", "TimeStep", "duration", "calendarDuration"));
        end

        if size(p.timeStep, "*") <> 1 then
            error(msprintf(_("%s: Wrong size for %s property: scalar expected.\n"), "timeseries", "TimeStep"));
        end

        step = p.timeStep;
        if isduration(step) then
            sampleRate = seconds(1) / step;
        else
            sampleRate = %nan;
        end
        
        startTime = out.vars(1).data(1);
        r = size(out.vars(1).data, 1);
        out.vars(1).data = (startTime:step:startTime + step * (r - 1))';
        p.sampleRate = sampleRate;
    end

    out.props = p;
endfunction
