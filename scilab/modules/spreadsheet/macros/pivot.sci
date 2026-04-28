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

function out = pivot(t, Columns, Rows, DataVariable, Method, ColumnsBinMethod, RowsBinMethod, IncludeTotals, IncludeEmptyGroups, IncludedEdge)

    n = checkNamedArguments()
    if n <> [] then
        n = sci2exp(n);
        error(msprintf(_("%s: Wrong named arguments used: %s.\n"), "pivot", n));
    end
    
    fname = "pivot";
    out = [];
    groupvars = [];
    groupbins = {};

    if ~istable(t) & ~istimeseries(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: A table or timeseries expected.\n"), fname, 1));
    end

    varnames = t.props.variableNames;
    
    if isdef("Rows", "l") then
        [tmp, idx] = members(Rows, varnames);
        if or(idx == 0) then
            error(msprintf(_("%s: Wrong value for ""%s"" argument: valid grouping variable name expected.\n"), fname, "Rows"));
        end

        groupvars = [groupvars, Rows];

        if isdef("RowsBinMethod", "l") then
            if or(typeof(RowsBinMethod) == ["string", "constant", "duration", "calendarDuration", "datetime"]) then
                RowsBinMethod = {RowsBinMethod};
            end
        else
            RowsBinMethod = num2cell("none" + emptystr(Rows));
        end
        groupbins(1:size(RowsBinMethod, "*")) = RowsBinMethod;
    end

    if isdef("Columns", "l") then
        [tmp, idx] = members(Columns, varnames);
        if or(idx == 0) then
            error(msprintf(_("%s: Wrong value for ""%s"" argument: valid grouping variable name expected.\n"), fname, "Columns"));
        end

        groupvars = [groupvars, Columns];

        if isdef("ColumnsBinMethod", "l") then
            if or(typeof(ColumnsBinMethod) == ["string", "constant", "duration", "calendarDuration", "datetime"]) then
                ColumnsBinMethod = {ColumnsBinMethod};
            end
        else
            ColumnsBinMethod = num2cell("none" + emptystr(Columns));
        end
        groupbins($+1:$+size(ColumnsBinMethod, "*")) = ColumnsBinMethod;
    end
    
    if isdef("DataVariable", "l") then
        if size(DataVariable, "*") <> 1 then
            error(msprintf(_("%s: Wrong value for ""%s"" argument: one variable name expected.\n"), fname, "DataVariable"));
        end
        if and(DataVariable <> varnames) then
            error(msprintf(_("%s: Wrong value for ""%s"" argument: valid variable name expected.\n"), fname, "DataVariable"));
        end
    else
        DataVariable = []
    end

    includePercent = %f;
    if isdef("Method", "l") then
        if typeof(Method) == "string" then
            if size(Method, "*") <> 1 then
                error(msprintf(_("%s: Wrong value for ""%s"" argument: one method expected.\n"), fname, "Method"));
            end

            if Method == "count" then
                Method = "";
            elseif Method == "percentage" then
                Method = "";
                includePercent = %t;
            end
        end
    else
        if DataVariable == [] then
            Method = ""
        else
            Method = "sum";
        end
    end

    if isdef("IncludeTotals", "l") then
        if type(IncludeTotals) <> 4 then
            error(msprintf(_("%s: Wrong type for ""%"" argument: A boolean expected.\n"), fname, "IncludeTotals"));
        end
    else
        IncludeTotals = %f;
    end

    if isdef("IncludeEmptyGroups", "l") then
        if type(IncludeEmptyGroups) <> 4 then
            error(msprintf(_("%s: Wrong type for ""%"" argument: A boolean expected.\n"), fname, "IncludeTotals"));
        end
    else
        IncludeEmptyGroups = %f;
    end

    if isdef("IncludedEdge", "l") then
        if type(IncludedEdge) <> 10 then
            error(msprintf(_("%s: Wrong type for ""%"" argument #%d: A string expected.\n"), fname, "IncludedEdge"));
        end

        if and(IncludedEdge <> ["left", "right"]) then
            error(msprintf(_("%s: Wrong value for ""%"" argument: ""%s"" or ""%s"" expected.\n"), fname, "IncludedEdge", "left", "right"));
        end
    else
        IncludedEdge = "left";
    end
    
    if typeof(Method) == "string" && Method == "" then
        g = groupcounts(t, groupvars, groupbins, "IncludeEmptyGroups", IncludeEmptyGroups, "IncludePercentGroups", includePercent, "IncludedEdge", IncludedEdge);
        if includePercent then
            res = g.Percent;
        else
            res = g.GroupCount;
        end
    else
        g = groupsummary(t, groupvars, groupbins, Method, DataVariable, "IncludeEmptyGroups", IncludeEmptyGroups, "IncludedEdge", IncludedEdge);
        res = g(g.Properties.VariableNames($));
    end    

    if ~isdef("Columns", "l") then
        // pivot(t, Rows = ["var1", "var2"], ...) but not Columns
        if Method <> "" then
            g.GroupCount = [];
        end
        if or(IncludeTotals) then
            if size(IncludeTotals, "*") <> 1 then
                error(msprintf(_("%s: Wrong value for %s argument: A scalar boolean expected.\n"), fname, "IncludeTotals"));
            end
            val = {};
            for i = 1:size(groupvars,"*")
                if i == 1 then
                    v = "Total";
                else
                    v = "";
                end
                val = string(g.vars(i).data);
                val($+1) = v;
                g.vars(i).data = val;  
            end
            g.vars($).data($+1) = max(size(t));
        end  
        out = g

    elseif ~isdef("Rows", "l") then
        // pivot(t, Columns = ["var1", "var2"], ...) but not Rows
        if size(IncludeTotals, "*") <> 1 then
            error(msprintf(_("%s: Wrong value for %s argument: A scalar boolean expected.\n"), fname, "IncludeTotals"));
        end
        
        [tmp, index] = members(groupvars, varnames);
        groupvars = index;
        [combinationsCol, count, index, u] = %_groupcounts(t, groupvars, groupbins, IncludeEmptyGroups, IncludedEdge);

        colnames = [];
        for i = 1:size(u)
            colnames = [colnames, string(combinationsCol(i))];
        end
        colnames = strcat(colnames, "_", "c")

        mat = matrix(res, size(colnames, "*"), 1)';
        if IncludeTotals then
            mat($+1) = max(size(t));
            colnames($+1) = "Total";
        end

        out = table(mat, "VariableNames", [colnames'])

    else

        [tmp, index] = members(groupvars, varnames);
        groupvars = index;
        [val, count, index, u] = %_groupcounts(t, groupvars, groupbins, %t, IncludedEdge);

        r = size(Rows, "*");
        uv = list(u(1:r));
        if r <> 1 then
            rownames = %_combinations(uv);
        else
            rownames = uv;
        end

        uc = list(u(r+1:$));
        if size(uc) == 1 then
            colnames = string(uc(1));
        else
            combinationsCol = %_combinations(uc);

            colnames = [];
            for i = r+1:size(u)
                colnames = [colnames, string(combinationsCol(i-r))];
            end
            colnames = strcat(colnames, "_", "c")
        end        

        if ~IncludeEmptyGroups then
            // remove line where count = 0;
            mat = matrix(count, size(colnames, "*"), size(rownames(1), "*"));
            idx = sum(mat, "c")==0
            mat(idx, :) = [];
            colnames(idx) = [];
            // for i = 1:r
            //     rownames(i)(idx) = []
            // end
            mat(mat <> 0) = res;
            mat = mat';
        else
            mat = matrix(res, size(colnames, "*"), size(rownames(1), "*"))';
        end

        if or(IncludeTotals) then
            if or(size(IncludeTotals, "*") == [1 2]) then
                if size(IncludeTotals, "*") == 1 then
                    IncludeTotals = [%t %t];
                end

                if IncludeTotals(1) then
                    // Manage rows
                    for i = 1:size(rownames)
                        if i == 1 then
                            v = "Total";
                        else
                            v = "";
                        end
                        rownames(i) = string(rownames(i));
                        rownames(i)($+1) = v;  
                    end
                    r = sum(mat, "r");
                    mat = [mat; r];
                end

                if IncludeTotals(2) then
                    c = sum(mat, "c");
                    mat = [mat, c];
                    colnames = [colnames; "Total"];
                end
             else
                error(msprintf(_("%s: Wrong value for %s argument: A boolean or 1x2 or 2x1 boolean vector expected.\n"), fname, "IncludeTotals"));
            end
        end

        colnames = colnames';

        nb = members(Rows, colnames);
        if or(nb > 0) then
            var = "Var_" + Rows;
            Rows(nb==1) = var(nb==1);
            warning(msprintf(_("Duplicate variable names: add ""%s"" prefix."), "Var_"));
        end

        varnames = [Rows, colnames];
        out = table(rownames(:), mat, "VariableNames", varnames)
    end

endfunction
