// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [out, loc] = join(tleft, tright, varargin)

    arguments
        tleft {mustBeA(tleft, ["table", "timeseries"])}
        tright {mustBeA(tright, ["table", "timeseries"])}
        varargin
    end

    keys = [];
    keeponecopy = "";
    leftkeys = [];
    rightkeys = [];
    leftvariables = [];
    rightvariables = [];

    varnames_tleft = tleft.props.variableNames;
    varnames_tright = tright.props.variableNames;
    s = size(tleft, 1);

    if nargin > 2 then
        n = nargin-2;
        rhs = n;
        for i = n-1:-2:1
            if type(varargin(i)) <> 10 then
                break;
            end

            select convstr(varargin(i), "l")
            case "keys"
                keys = varargin(i+1);
                if and(type(keys) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A double or string expected.\n"), "join", i+1));
                end
            case "keeponecopy"
                keeponecopy = varargin(i+1);
                if type(keeponecopy) <> 10 then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), "join", i+1));
                end
            case "leftkeys"
                leftkeys = varargin(i+1);
                if and(type(leftkeys) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A double or string expected.\n"), "join", i+1));
                end
            case "rightkeys"
                rightkeys = varargin(i+1);
                if and(type(rightkeys) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A double or string expected.\n"), "join", i+1));
                end
            case "leftvariables"
                leftvariables = varargin(i+1);
                if and(type(leftkeys) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A double or string expected.\n"), "join", i+1));
                end
                if istimeseries(tleft) & or(leftvariables == varnames_tleft(1)) then
                    error(msprintf(_("%s: ""%s"", row Times of timeseries, is not supported in ""%s"".\n"), "join", varnames_tleft(1), varargin(i)));
                end
            case "rightvariables"
                rightvariables = varargin(i+1);
                if and(type(rightkeys) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: A double or string expected.\n"), "join", i+1));
                end
                if istimeseries(tright) & or(rightvariables == varnames_tright(1)) then
                    error(msprintf(_("%s: ""%s"", row Times of timeseries, is not supported in ""%s"".\n"), "join", varnames_tright(1), varargin(i)));
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), "join", i, varargin(i)));
            end
            rhs = rhs - 2;
        end
    end

    if keys <> [] && (leftkeys <> [] || rightkeys <> []) then
        error(msprintf(_("%s: Impossible to use the ""%s"" with ""%s"" and ""%s"".\n"), "join", "Keys", "LeftKeys", "RightKeys"));
    end

    if (leftkeys <> [] && rightkeys == []) || (leftkeys == [] && rightkeys <> []) then
        error(msprintf(_("%s: ""%s"" and ""%s"" must be used together.\n"), "join", "LeftKeys", "RightKeys"));
    end

    if leftkeys <> [] then
        if type(leftkeys) == 1 then
            if or(members(leftkeys, 1:size(varnames_tleft, "*")) == 0) then
                error(msprintf(_("%s: Wrong value for input argument ""%s"": valid index expected.\n"), "joint", "LeftKeys"));
            end
            leftkeys = varnames_tleft(leftkeys);
        end

        if type(rightkeys) == 1 then
            if or(members(rightkeys, 1:size(varnames_tright, "*")) == 0) then
                error(msprintf(_("%s: Wrong value for input argument ""%s"": valid index expected.\n"), "joint", "RightKeys"));
            end
            rightkeys = varnames_tright(rightkeys);
        end
        if istimeseries(tleft) & istimeseries(tright) then
            if leftkeys <> tleft.props.variableNames(1) then
                leftkeys($+1) = tleft.props.variableNames(1);
            end
            if rightkeys <> tright.props.variableNames(1) then
                rightkeys($+1) = tright.props.variableNames(1);
            end
        end
    else

        if keys == [] then
            idx = grep(varnames_tleft, varnames_tright);
            leftkeys = varnames_tleft(idx);
            rightkeys = leftkeys;
        else
            if type(keys) == 1 then
                if or(members(keys, 1:size(varnames_tleft, "*")) == 0) || or(members(keys, 1:size(varnames_tright, "*")) == 0)
                    error(msprintf(_("%s: Wrong value for input argument ""%s"": valid index expected.\n"), "joint", "Keys"));
                end
                keys = varnames_tleft(keys);
            end
            if istimeseries(tleft) & keys <> tleft.props.variableNames(1) then
                keys($+1) = tleft.props.variableNames(1);
            end

            leftkeys = keys;
            rightkeys = keys;
        end
    end

    v = zeros(s + size(tright, 1), size(leftkeys, "*"));
    for i = 1:size(leftkeys, "*")
        if leftkeys(i) == "Row" then
            values1 = tleft.Row;
            values2 = tright.Row;
        else
            values1 = tleft.vars(leftkeys(i) == varnames_tleft).data;
            values2 = tright.vars(rightkeys(i) == varnames_tright).data;
        end
        d = [values1; values2];
        [u, k, v(:, i), nb] = unique(d, "keepOrder");
    end

    [u, k, vindex, nbV] = unique(v, "r");
    idx_tleft = vindex(1:s);
    idx_tright = vindex(s+1:$);
    idx_tright(idx_tright == (nbV == 1)) = [];
    if size(unique(idx_tright, "r"), "*") <> size(idx_tright, "*") then
        error(msprintf(_("%s: The values contained to key variables of Tright must have unique values.\n"), "join"))
    end

    [_, loc] = members(idx_tleft, idx_tright);

    if or(loc == 0) then
        error(msprintf(_("%s: The values of the key variable in the left table must be present in the key variable in the right table.\n"), "join"));
    end

    if leftvariables <> [] then
        out = tleft(:, leftvariables);
    else
        out = tleft;
    end
    
    if rightvariables <> [] then
        index = members(varnames_tright, rightvariables) == 1
    else
        index = members(varnames_tright, rightkeys) == 0;
    end

    if or(index) then
        vout = out.props.variableNames;
        vr = varnames_tright(index);
        if keeponecopy == "" then
            idx = grep(vout, vr);
            if idx <> [] then
                for i = 1:length(idx)
                    v = vout(idx(i));
                    out.props.variableNames(idx(i)) = v + "_Tleft";
                    tright.props.variableNames(varnames_tright == v) = v + "_Tright";
                end
                vr = tright.props.variableNames(index);
            end
        else
            vr(grep(vr, keeponecopy)) = [];
        end

        out = [out tright(loc, vr)]
    end

endfunction
