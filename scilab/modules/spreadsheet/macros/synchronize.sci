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

function varargout = synchronize(varargin)
    rhs = nargin;
    sampleRate = [];
    step = [];
    timeStep = [];
    constant = 0;
    endValues = [];
    includedEdge = [];
    method = "default";
    newTime = "union";
    fname = "synchronize";

    if nargin < 2 then
        error(msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), fname, 2));
    end

    if nargin > 2 then
        for i = nargin-1:-2:-1
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
                if type(varargin(i)) == 10 && and(varargin(i) <> ["union", "intersection", "regular", "yearly", "monthly", "daily", "hourly", "minutely", "secondly"]) then
                    error(msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), fname, i, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge"""));
                end
                break;
            end

            rhs = rhs - 2;
        end
    end

    nbrhs = rhs;
    if rhs > 2 then
        if typeof(varargin(rhs-1)) <> "timeseries" then
            method = varargin(rhs);
            
            if and(type(method) <> [10 13 130]) then
                error(msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), fname, rhs));
            end
            if type(method) == 10 && and(method <> ["fillwithmissing", "fillwithconstant", "linear", "spline", "count", "firstvalue", "lastvalue", "mode"]) then
                error(msprintf(_("%s: Wrong value for input argument #%d: An user function or %s, %s, %s, %s, %s, %s, %s or %s methods expected.\n"), fname, rhs, """fillwithmissing""", """fillwithconstant""", """linear""", """spline""", """count""", """firstvalue""", """lastvalue""", """mode"""));
            end

            rhs = rhs - 1;
        end

        if typeof(varargin(rhs)) <> "timeseries" then
            newTime = varargin(rhs);
            
            if and(typeof(newTime) <> ["string", "datetime", "duration"]) then
                error(msprintf(_("%s: Wrong type for input argument #%d: A duration, datetime or string expected.\n"), fname, rhs));
            end
        
            if type(newTime) == 10 then
                if ~isscalar(newTime) then
                    error(msprintf(_("%s: Wrong size for input argument #%d: A single string expected.\n"), fname, rhs));
                end
                if and(newTime <> ["union", "intersection", "regular", "yearly", "monthly", "daily", "hourly", "minutely", "secondly"]) then
                    error(msprintf(_("%s: Wrong value for input argument #%d: %s, %s, %s, %s, %s, %s, %s, %s or %s expected.\n"), fname, rhs, """union""", """intersection""", """regular""", """yearly""", """monthly""", """daily""", """hourly""", """minutely""", """secondly"""));
                end
            elseif or(typeof(newTime) == ["datetime", "duration"]) && size(newTime, "c") <> 1 then
                error(msprintf(_("%s: Wrong size for input argument #%d: Column vector expected.\n"), fname, rhs));
            end

            rhs = rhs - 1;
        end
    end
    
    listTs = list();
    for i = 1:rhs
        if ~istimeseries(varargin(i)) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), fname, i));
        end
        listTs(i) = gsort(varargin(i), "g", "i");
    end

    // check missing values in rowtimes
    // NaT for datetime
    // NaN for duration
    rowtimes = listTs(1).vars(1).data;
    err_rowtimes = %f;
    if isdatetime(rowtimes) then
        if or(isnat(rowtimes)) then
            err_rowtimes = %t;
        end
    else
        if or(isnan(rowtimes)) then
            err_rowtimes = %t;
        end
    end
    if err_rowtimes then
        error(msprintf(_("%s: New time vector cannot contain missing times.\n"), fname));
    end

    timeStart = rowtimes(1);
    timeEnd = rowtimes($);
    for k = 2:length(listTs)
        rowtimes = listTs(k).vars(1).data;
        err_rowtimes = %f;
        if isdatetime(rowtimes) then
            if or(isnat(rowtimes)) then
                err_rowtimes = %t;
            end
        else
            if or(isnan(rowtimes)) then
                err_rowtimes = %t;
            end
        end
        if err_rowtimes then
            error(msprintf(_("%s: New time vector cannot contain missing times.\n"), fname));
        end

        if timeStart > rowtimes(1) then
            timeStart = rowtimes(1);
        end
        if timeEnd < rowtimes($) then
            timeEnd = rowtimes($);
        end
    end

    newTimes = [];
    removeLine = %f;

    select newTime
    case "union"
        // creation du vecteur temps        
        for ts = listTs
            newTimes = [newTimes; ts.vars(1).data];
        end
        newTimes = unique(gsort(newTimes, "g", "i"));

    case "intersection"
        newTimes = listTs(1).vars(1).data;
        typ = typeof(newTimes);
        for k = 2:length(listTs)
            ts = listTs(k).vars(1).data;
            if typ == "datetime" then
                [_nb, loc] = members([newTimes.date newTimes.time], [ts.date ts.time], "rows")
                newTimes(loc == 0) = [];
            else
                [_nb, loc] = members(newTimes.duration, ts.duration);
                newTimes(loc == 0) = [];
            end
        end
    else
        if or(typeof(newTime) == ["datetime", "duration"]) then
            newTimes = newTime;
        else
            ts = listTs(1);
            ts = timeseries([timeStart; timeEnd], ts.vars(2).data([1 $]));
            newts = retime(ts, newTime, varargin(nbrhs+1:nargin))
            newTimes = newts.vars(1).data;
            if newTimes($) > timeEnd then
                removeLine = %t;
            end
        end
    end

    if or(nargout == [0, 1]) then
        out = [];
        varNames = [];
        l = list()
        timeName = [];
        for k = 1:length(listTs)
            ts = listTs(k);
            l(k) = ts.props.variableNames(2:$);
            timeName = [timeName ts.props.variableNames(1)];
            varNames = [varNames, l(k)];
            if ~isnan(ts.Properties.SampleRate) then
                ts.props.sampleRate = %nan;
                ts.props.timeStep = duration(%nan);
            end
            res = retime(ts, newTimes, method, varargin(nbrhs+1:nargin));
            // pour ne pas avoir les memes noms
            res.props.variableNames(2:$) = l(k) + "_ts"+ string(k);
            out = [out res]
        end

        if removeLine then
            out($,:) = [];
        end

        for i = 1:length(l)
            nb = members(l(i), varNames);
            if or(nb <> 1) then
                l(i)(nb <> 1) = l(i)(nb <> 1) + "_ts" + string(i);
            end
        end

        timeName = unique(timeName);
        timeName(timeName == "Time") = [];
        if isempty(timeName) then
            timeName = "Time";
        end

        out.props.variableNames = [timeName(1), list2vec(l)'];
        varargout(1) = out;
    else
        for ts = listTs
            varargout($+1) = retime(ts, newTimes, method, varargin(rhs+3:nargin));
        end 
    end
endfunction
