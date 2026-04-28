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

function out = rowfun(varargin)
    fname = "rowfun";
    groupingVariables = "";
    inputVariables = "";
    outputVariable = "";
    numOutputs = 0;

    rhs = nargin
    if rhs > 2 then
        for i = nargin-1:-2:3
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end
            select convstr(varargin(i), "l")
            case "groupingvariables" 
                groupingVariables = varargin(i + 1);
                if and(type(groupingVariables) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: string or double vector expected.\n"), fname, i));
                end
            case "inputvariables"
                inputVariables = varargin(i + 1);
                if and(type(inputVariables) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: string or double vector expected.\n"), fname, i));
                end
            case "outputvariablenames"
                outputVariable = varargin(i + 1);
                if type(outputVariable) <> 10 then
                    error(msprintf(_("%s: Wrong type for input argument #%d: string vector expected.\n"), fname, i));
                end
            case "numoutputs"
                numOutputs = varargin(i + 1);
                if and(type(numOutputs) <> [1 10]) then
                    error(msprintf(_("%s: Wrong type for input argument #%d: double expected.\n"), fname, i));
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: ''%s'' not allowed.\n"), fname, i, varargin(i)));
            end
        end
    end

    method = varargin(1);
    if and(typeof(method) <> ["function", "fptr"]) then
        error(msprintf(_("%s: Wrong type for input argument #%d: function expected.\n"), fname, 1));
    end

    t = varargin(2);
    if ~istable(t) & ~istimeseries(t) then
        error(msprintf(_("%s: Wrong type for input argument #%d: table or timeseries expected.\n"), fname, 2));
    end

    [t, varnames, groupingVariables] = %_checkinputVariable(t, inputVariables, groupingVariables)

    // compute
    nb = size(outputVariable, "*");
    
    if outputVariable == "" then
        if numOutputs == 0 then
            nb = 1;
            outputVariable = "Var1";
        else
            nb = numOutputs;
            outputVariable = "Var" + string(1:nb);
        end
    end

    out = [];
    dt = [];

    if groupingVariables <> "" then
        method = list(method);
        opts = struct("includeEmpty", %f, ...
                "method", method, ...
                "nameMethod", "", ...
                "outputVariable", outputVariable, ...
                "nb", nb);
        out = %_rowvarfun(fname, t, groupingVariables, opts)

    else

        res = list();
        if istimeseries(t) then
            l = t.vars(2:size(t, 2) + 1).data;
            dt = t.vars(1).data;
        else
            l = t.vars(1:size(t, 2)).data;
        end

        execstr("[" + strcat("tmp"+string(1:nb)', ",") + "] = method(l(:))");

        for i = 1:nb
            execstr("res(" + string(i) + ") = tmp"+ string(i) + "");
        end
        
        out = [out table(res(:), "VariableNames", outputVariable)];
    
        if istimeseries(t) then
            if dt <> [] then
                out = table2timeseries(out, "RowTimes", dt, "VariableNames", [varnames(1), out.props.variableNames])
            else
                out = table2timeseries(out);
            end
        end
    end    

endfunction
