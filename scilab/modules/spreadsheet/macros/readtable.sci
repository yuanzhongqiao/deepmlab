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

function tt = readtable(varargin)

    fname = "readtable"
    rhs = nargin;
    names = "";
    readrownames = %f;

    if rhs > 2 then
        for i = nargin-1:-2:2
            if type(varargin(i)) <> 10 then
                break;
            end
            select convstr(varargin(i), "l")
            case "variablenames"
                names = varargin(i + 1);
                if type(names) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument: string expected.\n"), fname, varargin(i)));
                end
            case "readrownames"
                readrownames = varargin(i + 1);
                if type(readrownames) <> 4 then
                    error(msprintf(_("%s: Wrong type for %s argument: boolean expected.\n"), fname, varargin(i)));
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), fname, i, varargin(i)));
            end

            rhs = rhs - 2;
        end
    end

    filename = varargin(1);
    f = mgetl(filename);

    if nargin == 2 || rhs >= 2 then
        opts = varargin(2);
    else
        opts = detectImportOptions(f);
    end

    variableNames = opts.variableNames;
    variableTypes = opts.variableTypes;

    if variableNames == [] then
        variableNames = ["Var" + string(1:size(variableTypes, "*"))];
    end
    
    fmt = opts.inputFormat;

    if names <> "" then
        [nb, _kk] = members(names, variableNames);
        if and(nb == 0) then
            error(msprintf(_("%s: no matching VariableNames.\n"), "readtimeseries"));
        end
        variableNames = names;
        variableTypes = variableTypes(_kk);
        fmt = fmt(_kk);
    else
        _kk = 1:$;
    end

    idx = find(variableNames == "Row")
    if idx <> [] then
        variableNames(idx) = "Var" + string(idx);
    end

    mat = csvTextScan(f(opts.datalines, :), opts.delimiter, opts.decimal, "string");//(:,_kk);
    mat = mat(:, _kk);

    l = list();
    for j = 1:size(mat, 2)
        m = mat(:,j)
        select variableTypes(j)
        case "duration"
            d = duration(0) .* ones(m);
            d(m <> "") = duration(mat(m <> "", j), "InputFormat", fmt(j));
            d(m == "") = duration(%nan);
            l($+1) = d;
        case "datetime"
            d = NaT(m);
            d(m <> "") = datetime(mat(m <> "", j), "InputFormat", fmt(j));
            l($+1) = d;
        case "double"
            l($+1) = strtod(m)
        case "boolean"
            idx = find(m == "");
            if idx <> [] then
                m(idx) = "%nan";
            end
            execstr("d = [" +strcat(m, ",") +"]")
            l($+1) = d'
        else
            l($+1) = m
        end
    end

    tt = table(l(:), "VariableNames", variableNames);
    tt.props.variableDescriptions = variableNames;

    if readrownames then
        tt.Row = tt.vars(1).data;
        tt(:,1) = [];
    end
endfunction
