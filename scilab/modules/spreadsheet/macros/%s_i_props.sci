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

function out = %s_i_props(varargin)
    out = varargin($);
    val = varargin(2);

    select varargin(1)
    case "Description"
        out.description = val;
    case "VariableNames"
        if val == [] then
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
        out.variableNames = val;
    case "VariableDescriptions"
        out.variableDescriptions = emptystr(out.variableNames);;
    case "VariableUnits"
        out.variableUnits = emptystr(out.variableNames);;
    case "VariableContinuity"
        out.variableContinuity = emptystr(out.variableNames);
    case "RowNames"
        out.rowNames = val;
    case "SampleRate"
        //will be check in props_i_timeseries
        out.sampleRate = val;
    else
        error(msprintf(_("Unknown field: %s.\n"), varargin(1)));
    end
endfunction
