// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = addvars(varargin)

    fname = "addvars";
    rhs = nargin;
    if rhs < 2 then
        error(msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), fname, 2));
    end

    after = %f;
    before = %f;
    location = "";
    numloc = 0;
    newvarnames = "";
    numvar = 0;

    if nargin > 3 then
        for i = nargin-1:-2:3
            if (typeof(varargin(i)) <> "string")
                break;
            end
            select convstr(varargin(i), "l")
            case "after"
                after = %t;
                location = varargin(i+1);
                numloc = i;
            case "before"
                before = %t;
                location = varargin(i+1);
                numloc = i;
            case "newvariablenames"
                newvarnames = varargin(i+1);
                numvar = i;
            else
                break;
            end
            rhs = rhs - 2;
        end
    end

    if after & before then
        error(msprintf(_("%s: Impossible to have After and Before options together.\n"), fname));
    end

    in = varargin(1);
    if and(typeof(in) <> ["timeseries", "table"]) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A timeseries or table expected.\n"), fname, 1));
    end

    vars = list();
    [nbrows, nbcols] = size(in);
    for i = 2:rhs
        v = varargin(i);
        if and(typeof(v) <> ["constant", "boolean", "string", "duration", "datetime"]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), fname, i, sci2exp(["double", "boolean", "string", "duration", "datetime"])));
        end

        if size(v, 1) <> nbrows then
            error(msprintf(_("%s: Wrong size for input argument #%d: Must have the same number of rows as argument #%d.\n"), fname, i, 1));
        end
           
        vars(i-1) = v;
    end

    varnames = in.props.variableNames;
    if location <> "" then
        if size(location, "*") <> 1 then
            error(msprintf(_("%s: Wrong size for input argument #%d: A scalar expected.\n"), fname, numloc));
        end
        select typeof(location)
        case "constant"
            if location < 1 | location > nbcols then
                error(msprintf(_("%s: Wrong value for input argument #%d: Must be positive and lower than or equal %d.\n"), fname, numloc, nbcols));
            end
            if istimeseries(in) then
                location = location + 1;
            end
            location = varnames(location);
        case "string"
            if and(location <> varnames) then
                error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), fname, numloc, nbcols));
            end
        else
            error(msprintf(_("%s: Wrong type for input argument #%d: %s expected.\n"), fname, numloc, sci2exp(["double", "string"])));
        end
    end

    if newvarnames <> "" then
        if typeof(newvarnames) <> ["string", "ce"] then
            error(msprintf(_("%s: Wrong type for input argument #%d: A string or cell of strings expected.\n"), fname, numvar));
        end
        if size(vars) <> size(newvarnames, "*") then
            error(msprintf(_("%s: Wrong size for input argument #%d: Names of added variables must match the variables to add.\n"), fname, numvar));
        end
    
        varnames2 = [];

        if typeof(newvarnames) == "ce" then
            tmp = [];
            for i = 1:size(newvarnames, "*")
                v = newvarnames{i}
                if type(v) <> 10 then
                    error(msprintf(gettext("%s: Wrong type for input argument #%d: A cell containing only strings expected."), fname, numvar));
                end
                tmp = [tmp, v];
            end
            newvarnames = tmp;
        end

        for i = 1:size(vars)
            if size(vars(i), 2) <> 1 then
                // vars(i) can be contain a column vector and matrix
                varnames2 = [varnames2 newvarnames(i) + "_" + string(1:size(vars(i), 2))];
            else
                varnames2 = [varnames2 newvarnames(i)];
            end
        end
        nb = members(varnames2, varnames);
        if or(nb <> 0) then
            error(msprintf(_("%s: Wrong value for ""%s"" option: duplicate variable name ""%s""."), fname, "NewVariableNames", sci2exp(varnames2(nb<>0))));
        end
    else
        s = size(in, 2);
        varnames2 = [];
        for i = 1:size(vars)
            if size(vars(i), 2) <> 1 then
                varnames2 = [varnames2, "Var" + string(s+i) + "_" + string(1:size(vars(i), 2))];
            else
                varnames2 = [varnames2, "Var" + string(s+i)];
            end
        end
        nb = members(varnames2, varnames);
        if or(nb <> 0) then
            varnames2(nb <> 0) = varnames2 + "_" + string(nb);
        end
    end

    out = [];
    if istable(in) then
        t = table(vars(:), "VariableNames", varnames2);
        if location <> "" then
            idx = find(varnames == location);
        end
    else
        timeName = in.Properties.VariableNames(1)
        t = timeseries(in(timeName), vars(:), "VariableNames", [timeName, varnames2]);
        if location <> "" then
            idx = find(varnames == location) - 1;
        end
    end

    if before then
        if idx > 1 then
            out = in(:, 1:idx-1);
        end

        out = [out, t];
        out = [out, in(:, idx:$)];

    elseif after then
        out = in(:, 1:idx);

        out = [out, t];

        if idx < size(in, 2) then
            out = [out in(:, idx+1:$)];
        end
        
    else
        out = in;        
        out = [out, t];
    end

endfunction