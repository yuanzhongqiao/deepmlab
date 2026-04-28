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

function g = groupcounts(varargin)

    rhs = nargin;
    fname = "groupcounts";

    if nargin < 2 then
        error(msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), fname, 2));
    end
    
    includeEmpty = %f;
    includePercent = %f;
    includedEdge = "left";
    percent = [];
    groupbins = "none";

    if nargin > 3 then
        // test des Name-Value Arguments
        for i = nargin-1:-2:3
            if type(varargin(i)) <> 10 then
                break;
            end

            select convstr(varargin(i), "l")
            case "includeemptygroups"
                includeEmpty = varargin(i + 1);
                if type(includeEmpty) <> 4 then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A boolean expected.\n"), fname, i));
                end
            case "includepercentgroups"
                includePercent = varargin(i + 1);
                if type(includePercent) <> 4 then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A boolean expected.\n"), fname, i));
                end
            case "includededge"
                includedEdge = varargin(i+1);
                if type(includedEdge) <> 10 then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, i+1));
                end

                if and(includedEdge <> ["left", "right"]) then
                    error(msprintf(_("%s: Wrong value for input argument #%d: ""%s"" or ""%s"" expected.\n"), fname, i+1, "left", "right"));
                end   
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), fname, i, varargin(i)));
            end
            rhs = rhs - 2;
        end
    end

    t = varargin(1);
    if ~istable(t) && ~istimeseries(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A table or timeseries expected.\n"), fname, 1));
    end

    groupvars = varargin(2);
    varnames = t.props.variableNames;
    previousname = "";

    // check groupvars
    select type(groupvars)
    case 1
        if or(groupvars > size(t, 2)) then
            error(msprintf(_("%s: Wrong value for input argument #%d: valid index expected.\n"), fname, 2));
        end

        if istimeseries(t) then
            groupvars = groupvars + 1;
        end
    case 10
        [a, index] = members(groupvars, varnames);
        if or(index == 0) then
            error(msprintf(_("%s: Wrong value for input argument #%d: valid grouping variable name expected.\n"), fname, 2));
        end
        groupvars = index;
    else
        error(msprintf(_("%s: Wrong type for input argument #%d: A string or double vector expected.\n"), fname, 2));
    end

    
    if rhs == 3 then
        // groupbins
        // groupcounts(t, groupvars, groupbins, opts)
        groupbins = varargin(3);

        select typeof(groupbins)
        case "constant"
            for i = groupvars
                if type(t.vars(i).data) <> 1 then
                    error(msprintf(_("%s: groupbins and groupvars must be double.\n"), fname, 3))
                end
            end
            previousname = "disc_";

        case {"datetime", "duration", "calendarDuration"}
            for i = groupvars
                if and(typeof(t.vars(i).data) <> ["duration", "datetime"]) then
                    error(msprintf(_("%s: groupvars must be a datetime or duration vector to apply groupbins.\n"), fname))
                end
            end
            if typeof(groupbins) == "calendarDuration" & size(groupbins) <> 1 then
                error(msprintf(_("%s: Wrong size for input argument #%d: a calendarDuration of size 1x1 expected.\n"), "groupcounts", 3));
            end
            previousname = "";
        else
            defaultGroupbins = ["none","second", "minute", "hour", "day", "month", "year", "dayname", "monthname"];
            previousname = emptystr(1, size(groupbins, "*"));

            if size(groupbins, "*") <> 1 && size(groupbins, "*") <> size(groupvars, "*") then
                error(msprintf(_("%s: Wrong size for input argument #%d: Must be the same size as #%d.\n"), fname, 3, 2));
            end

            if size(groupbins, "*") == 1 then
                if typeof(groupbins) == "ce" then
                    groupbins = groupbins{1};
                end
                if groupbins <> "none" then
                    for i = 1:size(groupvars, "*")
                        if ~isdatetime(t.vars(groupvars(i)).data) && ~isduration(t.vars(groupvars(i)).data) then
                            error(msprintf(_("%s: Wrong value for input argument #%d.\n"), fname, 3))
                        end
                    end
                end
            end

            if typeof(groupbins) == "string" then
                [tmp, idx] = members(groupbins, defaultGroupbins);
                if or(idx == 0) then
                    errargs = sci2exp(defaultGroupbins);
                    error(msprintf(_("%s: Wrong value for input argument #%d: %s expected.\n"), fname, 3, errargs));
                end
                
                if idx(idx <> 1) <> [] then
                    previousname(idx <> 1) = defaultGroupbins(idx(idx <> 1)) + "_";
                end

            elseif typeof(groupbins) == "ce" then
                for k = 1:size(groupbins, "*")
                    bins = groupbins{k};
                    if typeof(bins) == "constant" then
                        if type(t.vars(groupvars(k)).data) <> 1 then
                            error(msprintf(_("%s: Wrong data type for #%d: A double expected.\n"), fname, 3))
                        end
                        previousname(k) = "disc_";

                    elseif typeof(bins) == "string" then
                        if and(bins <> defaultGroupbins) then
                            errargs = sci2exp(defaultGroupbins);
                            error(msprintf(_("%s: Wrong value for input argument #%d: %s expected.\n"), fname, 3, errargs));
                        end
                        if bins <> "none" then
                            previousname(k) = bins + "_";
                        end
                    end
                end
            end
        end
    end

    if isdef("index", "l") & (rhs == 2 || (rhs == 3 && size(groupbins, "*") == 1)) then
        groupvars = unique(index, "keepOrder");
    end

    [uniqueGroupvars, ki2] = unique(groupvars, "keepOrder");
    if typeof(groupbins) <> "ce" then
        [uniqueGroupbins, ki1] = unique(groupbins, "keepOrder");
        
    else
        uniqueGroupbins = {};
        ki1 = [];
        tmp = groupbins;

        while tmp <> {}
            val = tmp{1};
            for k = 1:size(groupbins, "*")
                if typeof(val) == typeof(groupbins{k}) then
                    if find(val == groupbins{k}) then
                        ki1 = [ki1, k];
                        break;
                    end
                end
            end

            jdx = 1;
            for j = 2:size(tmp, "*")
                if typeof(val) == typeof(tmp{j}) then
                    if find(val == tmp{j}) then
                        jdx = [jdx j];
                    end
                end
            end
            tmp(jdx) = [];
            uniqueGroupbins{1,$+1} = val;
        end
    end

    if size(uniqueGroupbins) == size(uniqueGroupvars) & and(ki1 == ki2) then
        groupbins = uniqueGroupbins;
        groupvars = uniqueGroupvars;
        previousname = previousname(ki1);
    end

    [val, count, vindex] = %_groupcounts(t, groupvars, groupbins, includeEmpty, includedEdge);

    g = table(val(:), count, "VariableNames", [previousname + varnames(groupvars) "GroupCount"]); 
     
    if includePercent then
        percent = count ./sum(count)*100;
        g = [g table(percent, "VariableNames", "Percent")];
    end  
endfunction
