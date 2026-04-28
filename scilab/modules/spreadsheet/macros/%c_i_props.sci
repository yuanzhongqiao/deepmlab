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

function out = %c_i_props(varargin)
    //disp("c_i_props", varargin)
    out = varargin($);
    val = varargin(2);

    if and(varargin(1) <> ["Description", "RowNames"]) && (val <> "" && or(size(val) <> out.userdata)) then
        error(msprintf(_("%s: Wrong size for %s property.\n"), "%c_i_props", varargin(1)));
    end

    select varargin(1)
    case "Description"
        out.description = val;
    case "VariableNames"
        if val == "" then
            if or(fieldnames(out) == "timeStep") then
                // timeseries
                val(1) = "Time";
                for i = 2:prod(out.userdata)
                    val(1, i) = sprintf("Var%d", i - 1);
                end
            else
                // table
                for i = 1:prod(out.userdata)
                    val(1, i) = sprintf("Var%d", i);
                end
            end
        end

        if or(fieldnames(out) == "rowNames") & or(val == "Row") then
            error(msprintf(_("%s: ""%s"" can not be used.\n"), "c_i_props", "Row"));
        end
        out.variableNames = val;
    case "VariableDescriptions"
        if size(val, "*") == 1 then
            val = val + emptystr(out.variableNames);
        end
        out.variableDescriptions = val;
    case "VariableUnits"
        if size(val, "*") == 1 then
            val = val + emptystr(out.variableNames);
        end
        out.variableUnits = val;
    case "VariableContinuity"
        if size(val, "*") == 1 then
            val = val + emptystr(out.variableNames);
        end
        out.variableContinuity = val
    case "RowNames"
        out.rowNames = val;
    else
        error(msprintf(_("Unknown field: %s.\n"), varargin(1)));
    end

    out.userdata = [];
endfunction
