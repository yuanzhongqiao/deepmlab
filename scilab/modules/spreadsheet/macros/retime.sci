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

function out = retime(varargin)
    rhs = nargin;
    method = "default";
    sampleRate = [];
    step = [];
    timeStep = [];
    constant = 0;
    endValues = [];
    includedEdge = [];
    newTimes = [];
    fname = "retime";

    if nargin < 2 || nargin > 9 then
        error(msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), fname, 2, 9));
    end    

    if nargin > 2 then
        for i = nargin-1:-2:1
            if type(varargin(i)) <> 10 then
                break;
            end

            select convstr(varargin(i), "l")
            case "samplerate"
                sampleRate = varargin(i + 1);
                if type(sampleRate) <> 1 || ~isscalar(sampleRate) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), fname, i + 1));
                end
                step = duration(0, 0, 1 / sampleRate);
                //timeStep = step;
            case "timestep"
                timeStep = varargin(i + 1);
                if (~isduration(timeStep) && ~iscalendarDuration(timeStep)) || or(size(timeStep) <> [1 1]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A duration or calendarDuration expected.\n"), fname, i + 1));
                end
                step = timeStep;
                sampleRate = %nan;//seconds(1) / timeStep;
            case "constant"
                constant = varargin(i + 1);
                if type(constant) <> 1 || ~isscalar(constant) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), fname, i + 1));
                end
            // case "EndValues"
            //     endValues = varargin(i + 1);
            case "includededge"
                includedEdge = varargin(i + 1);
                if type(includedEdge) <> 10 || and(includedEdge <> ["left", "right"]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: %s or %s expected.\n"), fname, i + 1, """left""", """right"""));
                end
            else
                if type(varargin(i)) == 10 && and(varargin(i) <> ["regular", "yearly", "monthly", "daily", "hourly", "minutely", "secondly"]) then
                    error(msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), fname, i, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge"""));
                end
                break;
            end

            rhs = rhs - 2;
        end
    end

    ts = varargin(1);
    if ~istimeseries(ts) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), fname, 1));
    end

    ts = gsort(ts, "g", "i");
    timeStart = ts.vars(1).data(1);
    timeEnd = ts.vars(1).data($);

    newTime = varargin(2);
    if and(typeof(newTime) <> ["string", "datetime", "duration"]) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A duration, datetime or string expected.\n"), fname, 2));
    end

    if type(newTime) == 10 then
        if ~isscalar(newTime) then
            error(msprintf(_("%s: Wrong size for input argument #%d: A single string expected.\n"), fname, 2));
        end
        if and(newTime <> ["regular", "yearly", "monthly", "daily", "hourly", "minutely", "secondly"]) then
            error(msprintf(_("%s: Wrong value for input argument #%d: %s, %s, %s, %s, %s, %s or %s expected.\n"), fname, 2, """regular""", """yearly""", """monthly""", """daily""", """hourly""", """minutely""", """secondly"""));
        end
    elseif or(typeof(newTime) == ["datetime", "duration"]) && size(newTime, "c") > 1 then
        error(msprintf(_("%s: Wrong size for input argument #%d: Column vector expected.\n"), fname, 2));
    end

    if rhs == 3 then
        method = varargin(3);
        if and(type(method) <> [10 13 130]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), fname, 3));
        end
        if type(method) == 10 && and(method <> ["default", "fillwithmissing", "fillwithconstant", "linear", "spline", "count", "firstvalue", "lastvalue", "mode"]) then
            error(msprintf(_("%s: Wrong value for input argument #%d: An user function or %s, %s, %s, %s, %s, %s, %s or %s methods expected.\n"), fname, 3, """fillwithmissing""", """fillwithconstant""", """linear""", """spline""", """count""", """firstvalue""", """lastvalue""", """mode"""));
        end
    end

    newStart = timeStart;
    
    select newTime
    case "regular"
        if step == [] then
            error(msprintf(_("%s: Wrong number of input arguments: %s or %s are missing.\n"), fname, """TimeStep""", """SampleRate"""));
        end
        if typeof(newStart) == "duration" then //Sample rate
            // substract step to first time item
            if step <= newStart then
                t = newStart - step;
            else
                t = newStart;
            end

            sec1 = 1000;
            min1 = sec1 * 60;
            hour1 = min1 * 60;

            hh = modulo(floor(t.duration / hour1), 24);
            mm = modulo(floor(t.duration / min1), 60);
            ss = modulo(floor(t.duration / sec1), 60);

            /*  01:53:12
                hours: 00:00:00
                minutes: 01:00:00
                seconds: 01:53:00
            */

            if step >= hours(1) then
                t.duration = t.duration - (hh * 3600 + mm * 60 + ss) * 1000;

                if t + hours(24) <= newStart then
                    t = t + hours(24);
                end
            elseif step >= minutes(1)
                t.duration = t.duration - (mm * 60 + ss) * 1000;

                if t + hours(1) <= newStart then
                    t = t + hours(1);
                end
            elseif step >= seconds(1)
                t.duration = t.duration - ss * 1000;

                if t + minutes(1) <= newStart then
                    t = t + minutes(1);
                end
            else
                t.duration = floor(t.duration/1000) * 1000;

                if t + seconds(1) <= newStart then
                    t = t + seconds(1);
                end
            end           

            steps = t:step:newStart + step;
            idx = find(steps <= newStart);
            idx = max(idx);
            newStart = steps(idx);
        else //datetime
            d = datevec(newStart.date);
            if typeof(step) == "calendarDuration" then
                if step.y <> 0 then
                    d([2 3 4 5 6]) = [1 1 0 0 0];
                    newStart.time = 0;
                    newStart.date = datenum(d);
                elseif step.m <> 0 then
                    d([3 4 5 6]) = [1 0 0 0];
                    newStart.time = 0;
                    newStart.date = datenum(d);
                elseif step.d <> 0 then //into days
                    newStart.time = 0;
                elseif step.t >= hours(1) then
                    //
                elseif step.t >= minutes(1) then
                    // substract step to first time item
                    t = newStart - step;

                    h = floor (t.time / 3600);
                    s = t.time - 3600 * h;
                    mi = floor (s / 60);
                    s = s - 60 * mi;

                    //find previous hour
                    t.time = t.time - (mi * 60 + s);

                    if t + hours(1) < newStart then
                        t = t + hours(1);
                    end

                    steps = t:step:newStart+step;
                    idx = find(steps <= newStart);
                    idx = max(idx);
                    newStart = steps(idx);
                elseif step.t >= seconds(1) then
                    newStart.time = floor(newStart.time);
                else
                end
            else //duration
                // substract step to first time item
                t = newStart - step;

                h = floor (t.time / 3600);
                s = t.time - 3600 * h;
                mi = floor (s / 60);
                s = s - 60 * mi;

                if step >= hours(1) then
                    //find previous hour
                    t.time = t.time - (h * 3600 + mi * 60 + s);

                    if t + hours(24) <= newStart then
                        t = t + hours(24);
                    end
                elseif step >= minutes(1) then
                    //find previous hour
                    t.time = t.time - (mi * 60 + s);

                    if t + hours(1) <= newStart then
                        t = t + hours(1);
                    end
                elseif step >= seconds(1)
                    t.time = t.time - s;

                    if t + minutes(1) <= newStart then
                        t = t + minutes(1);
                    end
                else
                    t.time = t.time - floor(s);

                    if t + seconds(1) <= newStart then
                        t = t + seconds(1);
                    end
                end

                steps = t:step:newStart + step;
                idx = find(steps <= newStart);
                idx = max(idx);
                newStart = steps(idx);
            end
        end
    case "yearly"
        if typeof(newStart) == "duration" then
            newStart = years(floor(years(newStart)));
            step = years(1);
        else
            d = datevec(newStart.date);
            d([2 3 4 5 6]) = [1 1 0 0 0]; //set 1 to day and month and 0 to time
            newStart = datetime(d);
            step = calyears(1);
        end
    case "monthly"
        if typeof(newStart) == "duration" then
            error(msprintf(_("%s: %s can not be used with a timeseries that has duration row times.\n"), "retime", newTime))
        end
        d = datevec(newStart.date);
        d([3 4 5 6]) = [1 0 0 0]; //set 1 to day and month and 0 to time
        newStart = datetime(d, "OutputFormat", newStart.format);
        step = calmonths(1);
    case "daily"
        if typeof(newStart) == "duration" then
            newStart = days(floor(days(newStart)));
            step = days(1);
        else
            d = datevec(newStart.date);
            d([4 5 6]) = [0 0 0]; //set 0 to time
            newStart = datetime(d, "OutputFormat", newStart.format);
            step = caldays(1);
        end        
    case "hourly"
        if typeof(newStart) == "duration" then
            newStart = hours(floor(hours(newStart)));
        else
            newStart.time = floor(newStart.time / (60*60)) * (60*60);
        end

        step = hours(1);
    case "minutely"
        if typeof(newStart) == "duration" then
            newStart = minutes(floor(minutes(newStart)));
        else
            newStart.time = floor(newStart.time / 60) * 60;
        end

        step = minutes(1);
    case "secondly"
        if typeof(newStart) == "duration" then
            newStart = seconds(floor(seconds(newStart)));
        else
            newStart.time = floor(newStart.time);
        end

        step = seconds(1);
    else
        newTimes = newTime;
    end

    if newTimes == [] then
        if typeof(step) == "duration" then
            s = ceil(((timeEnd+step) - newStart) / step);
            steps = (0:s-1)'*step;
            newTimes = newStart + steps;
        else //calendarDuration
            if isdatetime(timeEnd) && timeEnd.time <> 0 || or(newTime == ["monthly", "yearly"]) then
                timeEnd = timeEnd + step;
            end
            newTimes = (newStart:step:timeEnd)';//+step)';
        end
    end
    
    oldTimes = ts.vars(1).data;
    out = [];

    props = ts.Properties;

    if or(type(method) == [130 13]) then //user defined method

            rowtimes = ts.vars(1).data;
            l = ts.vars;
            col = size(ts.vars, "*");

            if isdatetime(rowtimes) then 
                rowtimes = rowtimes.date * 24*60*60 + rowtimes.time;
                dt = newTimes.date * 24*60*60 + newTimes.time;
            else
                rowtimes = rowtimes.duration;
                dt = newTimes.duration;
            end
            
            left = %f;
            if type(newTime) <> 10 | includedEdge <> "right" then
                // for includeedge = left
                t1 = rowtimes >= dt(1);
                rowtimes = rowtimes(t1);
                t2 = rowtimes < dt($);
                rowtimes = rowtimes(t2);
                tmp = list();
                for k = 2:col
                    d = l(k).data;
                    d = d(t1);
                    d = d(t2);
                    tmp(k).data = d;
                end
                l = tmp;

                dt(2:$) = dt(2:$)-0.0001;
                left = %t;
                i = 1;
                idx = 1:$-1;

            else

                t = rowtimes <= dt(1);
                if or(t) then
                    data = list();
                    for k = 2:col
                        data($+1) = method(ts.vars(k).data(t));
                    end

                    out1 = timeseries(newTimes(1), data(:));
                end

                // rowtimes = rowtimes(rowtimes > dt(1));
                // rowtimes = rowtimes(rowtimes <= dt($));

                t1 = rowtimes > dt(1);
                rowtimes = rowtimes(t1);
                t2 = rowtimes <= dt($);
                rowtimes = rowtimes(t2);
                tmp = list();
                for k = 2:col
                    d = l(k).data;
                    d = d(t1);
                    d = d(t2);
                    tmp(k).data = d;
                end
                l = tmp;
                i = 2;
                idx = 2:$;
            end

            [i_bin, counts, outside] = dsearch(rowtimes, dt);

            enditer = cumsum(counts);
            iter = [1; enditer(1:$-1)+1];            

            data = list();
            for k = 2:col
                mat = [];
                for c = 1:length(iter)
                    mat = [mat; method(l(k).data(iter(c):enditer(c)))];
                end
                data($+1) = mat;
            end

            out = timeseries(newTimes(idx), data(:))

            if left then
                if type(newTime) == 10 then
                    t = ts.vars(1).data >= newTimes($);
                    if or(t) then
                        data = list();
                        for k = 2:col
                            data($+1) = method(ts.vars(k).data(t));
                        end
                        out = [out ; timeseries(newTimes($), data(:))]
                    end
                else
                    t = ts.vars(1).data == newTimes($);
                    data = list();
                    for k = 2:col
                        data($+1) = method(ts.vars(k).data(t));
                    end
                    out = [out ; timeseries(newTimes($), data(:))]
                end

            else
                if isdef("out1", "l") then
                    out = [out1; out];
                end
            end

            if type(newTime) == 10 then
                newTimes = out.vars(1).data;
            end

    elseif or(method == ["default" "fillwithmissing" "fillwithconstant"]) then
        /* pitêtre pitêtre pas
        if includedEdge == "right" then
            newTimes(1) = [];
        else
            newTimes($) = [];
        end
        */

        if method == "fillwithconstant" then
            if size(constant, "*") == 1 then
                cst = {};
                for i = 2:size(ts.vars, "*")
                    select type(ts.vars(i).data)
                    case 1
                        cst{$+1} = constant;
                    case 4
                        if constant == 0 then
                            cst{$+1} = %f;
                        else
                            cst{$+1} = %t;
                        end
                    case 10
                        cst{$+1} = string(constant)
                    case 17
                        if typeof(ts.vars(i).data) == "datetime" then
                            cst{$+1} = NaT();
                        else //duration
                            cst{$+1} = duration(0);
                        end
                    end
                end
                constant = cst;
            end
        else
            constant = {};
            for i = 2:size(ts.vars, "*")
                select type(ts.vars(i).data)
                case 1
                    constant{$+1} = %nan;
                case 4
                    constant{$+1} = %f;
                case 10
                    constant{$+1} = "<undefined>"
                case 17
                    if typeof(ts.vars(i).data) == "datetime" then
                        constant{$+1} = NaT();
                    else //duration
                        constant{$+1} = duration(0);
                    end
                end
            end
        end

        s = size(newTimes, 1);
        data = list();
        for i = 2:size(ts.vars, "*")
            data($+1) = constant{i-1};
        end

        dura = ts.vars(1).data;
        if typeof(newTimes) <> typeof(dura) then
            error(msprintf(_("%s: Wrong type for %s variable: a %s expected.\n"), fname, "newTimes", typeof(dura)));
        end

        if isdatetime(newTimes) then 
            d = dura.date * 24*60*60 + dura.time;
            nt = newTimes.date * 24*60*60 + newTimes.time;
        else
            d = dura.duration;
            nt = newTimes.duration;
        end

        [nb, idx] = members(d', nt');
        idx(idx == 0) = [];

        out = timeseries(newTimes, data(:));
        for u = unique(idx)
            out(u) = ts(newTimes(u), :)(1);
        end

        if method == "fillwithconstant" then
            for i = 2:size(out.vars, "*")
                idx = find(isnan(out.vars(i).data));
                if idx <> [] then
                    out.vars(i).data(idx) = data(i-1);
                end
            end
        end

        // props.sampleRate = out.props.sampleRate;
        // props.timeStep = out.props.timeStep;
        if method <> "fillwithmissing" && method <> "fillwithconstant" then
            //check variableContinuity
            for i = 2:size(out.vars, "*")
                if ts.props.variableContinuity(i) == "continuous" then
                    t_old = [];
                    t_new = [];
                    if typeof(ts.vars(1).data) == "duration" then
                        t_old = ts.vars(1).data.duration;
                        t_new = newTimes.duration;
                    else
                        t_old = ts.vars(1).data.date * (24*60*60) + ts.vars(1).data.time;
                        t_new = newTimes.date * (24*60*60) + newTimes.time;
                    end
                    
                    vals_old = ts.vars(i).data;
                    vals_new = interp1(t_old, vals_old, t_new, "linear", "extrap");
        
                    out.vars(i).data = vals_new;
                elseif ts.props.variableContinuity(i) == "step" then
                    // only double type is managed, for now...
                    if type(out.vars(i).data) == 1 then
                        d = out.vars(i).data;
                        idx = find(isnan(d));
                        idx(idx == 1) = [];
                        for j = idx
                            d(j) = d(j-1);
                        end
                        out.vars(i).data = d;
                    end
                end
            end
        end
    elseif method == "linear" | method == "spline" then
        out = ts;

        /* pitêtre pitêtre pas
        if includedEdge == "right" then
            newTimes(1) = [];
        else
            newTimes($) = [];
        end
        */

        out.vars(1).data = newTimes;

        t_old = [];
        t_new = [];
        if typeof(ts.vars(1).data) == "duration" then
            t_old = ts.vars(1).data.duration;
            t_new = newTimes.duration;
        else
            t_old = ts.vars(1).data.date * (24*60*60) + ts.vars(1).data.time;
            t_new = newTimes.date * (24*60*60) + newTimes.time;
        end

        for i = 2:size(ts.vars, "*")
            if type(ts.vars(i).data) <> 1 then
                error(msprintf(_("%s: Wrong type for %s variable: a double expected.\n"), fname, ts.props.variableNames(i)));
            end

            vals_old = ts.vars(i).data;
            vals_new = interp1(t_old, vals_old, t_new, method, "extrap");

            out.vars(i).data = vals_new;
        end
    else // user method (sum/mean)
        select method
        case "count"
            function r = userfunc(x)
                r = size(x, "*");
            endfunction
        case "firstvalue"
            function r = userfunc(x)
                if x(1) <> [] then
                    r = x(1);
                else
                    r = %nan;
                end
            endfunction
        case "lastvalue"
            function r = userfunc(x)
                if x($) <> [] then
                    r = x($);
                else
                    r = %nan;
                end
            endfunction
        case "mode"
            function r = userfunc(x)
                [_, _, _, nb] = unique(x);
                val = max(nb);
                r = x(find(nb == val))(1);
                if r == [] then
                    r = %nan;
                end
            endfunction
        end
        out = retime(ts, newTime, userfunc, varargin(4:$));
        return;
    end

    if size(newTimes, "*") > 1 then
        [tmp, step] = isregular(newTimes);
        if ~tmp then
            timeUnit = ["years", "months", "days"];
            for tu = timeUnit
                [tmp, step] = isregular(newTimes, tu)
                if tmp then
                    break;
                end
            end
        end
        if ~isnan(step) then
        //     timeStep = duration(step, 0,0);
        //     sampleRate = step;
        // else
            timeStep = step;
            if isduration(timeStep) then
                sampleRate = seconds(1) / timeStep;
            else
                sampleRate = %nan;
            end
            props.timeStep = timeStep;
            props.sampleRate = sampleRate;
        end
    end

    props.startTime = newTimes(1);
    out.Properties = props;
endfunction
