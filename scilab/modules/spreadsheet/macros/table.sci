// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function t = table(varargin)

    fname = "table";
    variableNames = [];
    rowNames = [];

    rhs = nargin
    if rhs == 0 then
        error(msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), fname, 1));
    end
    
    if typeof(varargin(1)) == "st" then
        st = varargin(1);
        variableNames = fieldnames(st)';
        l = list();
        for f = variableNames
            l($+1) = list2vec(st(f));
        end
        t = table(l(:), "VariableNames", variableNames, varargin(2:$));
        return
    end

    if rhs > 1 then
        for i = nargin-1:-2:2
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end

            select convstr(varargin(i), "l")
            case "variablenames"
                variableNames = varargin(i + 1);
                if type(variableNames) <> 10 then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: string vector expected.\n"), fname, "VariableNames"));
                end

                if or(variableNames == "") then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: no empty strings expected.\n"), fname, "VariableNames"));
                end

                idx = find(variableNames == "Row");
                if idx <> [] then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: ""%s"" can not be used.\n"), fname, "VariableNames", "Row"));
                end

                [uniqueNames, km, ku, nb] = unique(variableNames);
                if or(nb > 1) then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: unique variable names expected.\n"), fname, "VariableNames"));
                end

            case "rownames"
                rowNames = varargin(i + 1);

                if type(rowNames) <> 10 then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: string vector expected.\n"), fname, "RowNames"));
                end

                if rowNames == "" then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: no empty string expected.\n"), fname, "RowNames"));
                end

            else
                break;
            end
            
            rhs = rhs - 2;
        end
    end

    data = []; //list();
    ref_size = size(varargin(1));
    for i = 1:rhs
        tmp = varargin(i);
        typ = ["constant", "boolean", "string", "duration", "datetime", "calendarduration", "uint8", "uint16", "uint32", "uint64", "int8", "int16", "int32", "int64", "ce"];
        if and(typeof(tmp) <> typ) then
            error(msprintf(_("%s: Wrong type for input argument #%d: Must be %s.\n"), fname, i, varargin(i), sci2exp(typ)));
        end

        s = size(tmp);
        if s(1) <> ref_size(1) then
            error(msprintf(_("%s: Wrong size for input argument #%d.\n"), fname, i));
        end
        //d.data = tmp;
        n = size(data, "*")
        if s(2) > 1 then
            for j = 1:s(2)
                data(1, n + j).data = tmp(:, j);
            end
        else
            data(1, n + 1).data = tmp;
        end
    end

    if variableNames == [] then
        for i = 1:size(data, "*")
            variableNames(1, i) = sprintf("Var%d", i);
        end
    else
        if size(variableNames, "*") <> size([1:size(data, "*")], "*") then
            error(msprintf(_("%s: Wrong size of %s values.\n"), fname, "VariableNames"));
        end
    end

    if rowNames <> [] then
        if isvector(rowNames) && (size(rowNames, "*") == size(data(1).data, 1)) then
            if isrow(rowNames) then
                rowNames = rowNames';
            end
        else
            error(msprintf(_("%s: Wrong size for ""%s"" argument: Must be a vector containing %d elements.\n"), "table", "RowNames", size(data(1).data, 1)));
        end
    end

    props = mlist(["props", "description", "variableNames", "variableDescriptions", "variableUnits", "rowNames", "userdata"], ...
        "", variableNames, emptystr(variableNames), emptystr(variableNames), rowNames, []);

    t = mlist(["table", "props", "vars"], props, data);

endfunction
