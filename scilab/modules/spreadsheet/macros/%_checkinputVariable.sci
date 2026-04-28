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

function [t, varnames, groupingVariables] = %_checkinputVariable(t, inputVariables, groupingVariables)
    varnames = t.props.variableNames;
    idx = []; jdx = [];

    if inputVariables <> "" then
        if type(inputVariables) == 10 then
            [tmp, idx] = members(inputVariables, varnames);
            if or(idx == 0) then
                error(msprintf(_("%s: ""%s"" is not a table variable name.\n"), fname, inputVariables(idx == 0)));
            end
        else
            if inputVariables > size(t, 2) then
                error(msprintf(_("%s: Wrong value.\n"), fname));
            end
            idx = inputVariables;
        end

        if groupingVariables<> "" then
            if type(groupingVariables) == 10 then
                [tmp, jdx] = members(groupingVariables, varnames);
                if or(jdx == 0) then
                    error(msprintf(_("%s: ""%s"" is not a table variable name.\n"), fname, groupingVariables(jdx == 0)));
                end
            else
                if groupingVariables > size(t, 2) then
                    error(msprintf(_("%s: Wrong value.\n"), fname));
                end
                jdx = groupingVariables;
            end
        end
    
        if idx <> [] || jdx <> [] then
            if istimeseries(t) then
                if idx == 1 then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: valid variable name but not rowtimes.\n"), fname, "InputVariables"));
                end
                jdx(jdx == 1) = [];
                idx = idx - 1;
                if jdx <> [] then
                    jdx = jdx - 1;
                end
            end

            t = t(:, unique([jdx idx], "keepOrder"))
            varnames = t.props.variableNames;
            if type(groupingVariables) == 1 then
                groupingVariables = 1:length(jdx);
            end
        end
    end
endfunction
