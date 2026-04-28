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

function out = %props_e(varargin)
    p = varargin($);
    select varargin(1)
    case "Description"
        out = p.description;
    case "StartTime"
        out = p.startTime;
    case "SampleRate"
        out = p.sampleRate;
    case "TimeStep"
        out = p.timeStep;
    case "VariableNames"
        out = p.variableNames;
    case "VariableDescriptions"
        out = p.variableDescriptions;
    case "VariableUnits"
        out = p.variableUnits;
    case "VariableContinuity"
        out = p.variableContinuity;
    case "RowNames"
        out = p.rowNames;
    else
        error(msprintf(_("Unknown field: %s.\n"), varargin(1)));
    end
endfunction
