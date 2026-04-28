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

function out = groupsummary(varargin)
    fname = "groupsummary";
    includeEmptyGroups = %f;
    includedEdge = "left";
    inputVariables = "";
    method = "";
    groupbins = "none";

    rhs = nargin;
    if nargin > 2 then
        // test des Name-Value Arguments
        for i = nargin-1:-2:2
            if type(varargin(i)) <> 10 then
                break;
            end

            select convstr(varargin(i), "l")
            case "includeemptygroups"
                includeEmptyGroups = varargin(i + 1);
                if type(includeEmptyGroups) <> 4 then
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
                break;
            end
            rhs = rhs - 2;
        end
    end

    t = varargin(1);
    if ~istable(t) & ~istimeseries(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A table or timeseries expected.\n"), fname, 1));
    end

    groupvars = varargin(2);
    if and(typeof(groupvars) <> ["string", "constant"]) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A string or double expected.\n"), fname, 2));
    end

    isGroupBins = %f;

    if rhs == 5 then
        inputVariables = varargin(5);
        if and(typeof(inputVariables) <> ["constant", "string", "ce"]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: A string, double or cell of strings expected.\n"), fname, rhs));
        end
        
        [method, nameMethod] = groupsummary_method(varargin(4));

        groupbins = varargin(3);
        isGroupBins = %t;
        
    elseif rhs == 4 then
        v = varargin(4)
        try
            [method, nameMethod] = groupsummary_method(v);
            groupbins = varargin(3);
            isGroupBins = %t;
        catch
            inputVariables = v;
            if and(typeof(inputVariables) <> ["constant", "string", "ce"]) then
                error(msprintf(_("%s: Wrong type for input argument #%d: A string, double or cell of strings expected.\n"), fname, rhs));
            end
            [method, nameMethod] = groupsummary_method(varargin(3));
        end
    elseif rhs == 3 then
        v = varargin(3)
        try
            [method, nameMethod] = groupsummary_method(v);
        catch
            groupbins = v;
            isGroupBins = %t;
        end
    end

    [tmp, idx] = members(t.Properties.VariableNames, groupvars);
    if and(idx <> 0) then
        // groupvars == varnames
        rhs = 2
    end

    out = [];

    if rhs == 2 then
        out = groupcounts(t, groupvars, "IncludeEmptyGroups", includeEmptyGroups, "IncludedEdge", includedEdge);
    elseif rhs == 3 && isGroupBins then
        out = groupcounts(t, groupvars, groupbins, "IncludeEmptyGroups", includeEmptyGroups, "IncludedEdge", includedEdge);
    else
        isT = istimeseries(t);
        if isT then
            t = timeseries2table(t);
        end

        if typeof(inputVariables) == "ce" then
            // rowfun
            sc = size(inputVariables, "*");
            s = size(inputVariables{1}, "*");
            inputVariables = unique(matrix(list2vec(inputVariables{:}),s, sc), "r");
            s = size(inputVariables, 1);
            nb = 1;
            gvarnames = [groupvars "GroupCount"];
            for j = 1:s
                [t2, varnames, groupvars] = %_checkinputVariable(t, inputVariables(j, :), groupvars)
                outputVariable = strcat(inputVariables(j,:), "_");
                // if size(method) == 1 then
                //     outputVariable = "func1_" + outputVariable;
                // end
                opts = struct("includeEmpty", includeEmptyGroups, ...
                "includedEdge", includedEdge, ...
                "method", method, ...
                "nameMethod", nameMethod, ...
                "outputVariable", outputVariable, ...
                "nb", nb);
                r = %_rowvarfun("rowfun", t2, groupvars, opts, groupbins);
                if j == 1 then
                    out = r;
                else
                    rnames = r.props.variableNames;
                    [tmp, jdx] = members(rnames, gvarnames);
                    out = [out r(:,jdx == 0)]
                end
            end

        elseif or(typeof(inputVariables) == ["constant", "string"]) then
            //varfun
            [t, varnames, groupvars] = %_checkinputVariable(t, inputVariables, groupvars)

            try
                opts = struct("includeEmpty", includeEmptyGroups, ...
                    "includedEdge", includedEdge, ...
                    "method", method, ...
                    "nameMethod", nameMethod);
                out = %_rowvarfun("varfun", t, groupvars, opts, groupbins)
            catch
                try
                    nb = 1;
                    [tmp, jdx] = members(groupvars, varnames);
                    v = varnames;
                    v(jdx) = [];
                    outputVariable = strcat(v, "_");
                    // if size(method) == 1 then
                    //     outputVariable = "fun_" + outputVariable;
                    // end
                    opts = struct("includeEmpty", includeEmptyGroups, ...
                        "includedEdge", includedEdge, ...
                        "method", method, ...
                        "nameMethod", nameMethod, ...
                        "outputVariable", outputVariable, ...
                        "nb", nb);
                    out = %_rowvarfun("rowfun", t, groupvars, opts, groupbins);
                catch
                    error(msprintf(_("%s: problem with function.\n"), "groupsummary"));
                end
            end
        end
    end
endfunction

function [m, name] = groupsummary_method(method)
    // Can be a string, function, fptr, cell
    // function and fptr : one value
    // string : scalar or matrix
    // cell : contains one or multiple function, fptr or string
    // Possible values : 
        // * "sum", "mean", "median", "mode", "var", "std", "min", "max", "range", "nummissing", "numunique", "nnz", "all"
        // sum, mean, median, min, max, range, nnz
        // userfunc
    
    typ = typeof(method);
    if and(typ <> ["string", "function", "fptr", "ce"]) then
        error(msprintf(_("%s: Wrong type for ""%s"" argument: A string, cell or function expected.\n"), "groupsummary", "method"));
    end
    previousprot = funcprot(0);

    m = list();
    name = [];
    select typ
    case "function"
        m(1) = method;
        name = "fun";
    case "fptr"
        m(1) = method
        name = "fun";
    case "string"
        s = size(method, "*");
        idx = find(method == "all");
        if idx <> [] then
            method = [method, "sum", "mean", "median", "mode", "var", "std", "min", "max", "range", "nummissing", "numunique", "nnz"];
            method(idx) = [];
            method = unique(method)
            [m, name] = groupsummary_method(method)
            return;
        end
        name = unique(method);
        for i = 1:s
            select method(i)
            case "mode"
                function r = %userfunc(x)
                    [x, _, _, nb] = unique(x);
                    val = max(nb);
                    r = x(find(nb == val))(1);
                    if r == [] then
                        r = %nan;
                    end
                endfunction
                m(i) = %userfunc;
            case "var"
                function r = %userfunc(x)
                    r = nanstdev(x).^2;
                endfunction
                m(i) = %userfunc;
            case "std"
                m(i) = nanstdev;
            case "range"
                m(i) = strange;
            case "nummissing"
                function r = %userfunc(x)
                    select x
                    case "constant"
                        r = length(find(isnan(x)));
                    case "string"
                        r = length(find(x == "undefined"));
                    case "datetime"
                        r = length(find(x == NaT()));
                    else
                        r = 0;
                    end
                endfunction
                m(i) = %userfunc;
            case "numunique"
                function r = %userfunc(x)
                    r = length(find(~isnan(x)));
                endfunction
                m(i) = %userfunc;
            case "median"
                m(i) = nanmedian;
            case "sum"
                m(i) = nansum;
            case "mean"
                m(i) = nanmean;
            else
                if and(method(i) <> ["min", "max", "nnz"]) then
                    errargs = sci2exp(["mean", "sum", "min", "max", "median", "mode", "nnz", "var", "std", "range", "nummissing", "numunique"]);
                    error(msprintf(_("%s: Wrong value of ""%s"" argument: %s expected.\n"), "groupsummary", "method", errargs));
                end
                execstr("m("+ string(i) + ") = " + method(i));
            end
        end
    case "ce"
        s = size(method, "*");
        for i = 1:s
            [r, n] = groupsummary_method(method{i})
            m(i) = r(1);
            name(i) = n;
        end

        // keep unique function names only on string ("max", ...)
        n = name(name <> "fun")
        [n, km, ku] = unique(n);
        c = 1:size(n, "*");
        c(km) = [];
        for i = 1:length(c)
            m(c(i)) = null();
        end
    end
    funcprot(previousprot)

endfunction
