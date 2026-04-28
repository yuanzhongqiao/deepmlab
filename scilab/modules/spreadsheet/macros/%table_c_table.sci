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

function out = %table_c_table(tb1, tb2)
    fname = "%table_c_table";
    rowNames_tb1 = tb1.props.rowNames;
    rowNames_tb2 = tb2.props.rowNames;
    rowNames = [];

    if rowNames_tb1 == rowNames_tb2 then
        rowNames = rowNames_tb1;
    elseif rowNames_tb1 == [] && rowNames_tb2 <> [] then
        rowNames = rowNames_tb2;
    elseif rowNames_tb1 <> [] && rowNames_tb2 == [] then
        rowNames = rowNames_tb1;
    else
        error(msprintf(_("%s: All tables must have the same rowNames.\n"), fname));
    end

    if size(tb1, 1) <> size(tb2, 1) then
        error(msprintf(_("%s: All tables must have the same number of rows.\n"), fname));
    end

    names = [tb1.props.variableNames, tb2.props.variableNames];
    unames = unique(names);
    if size(names, "*") <> size(unames, "*") then
        error(msprintf(_("%s: names in VariableNames must be different.\n"), fname));
    end

    data = [tb1.vars tb2.vars];
    p = tb1.props;
    p.variableNames = names;
    p.rowNames = rowNames;
    p.variableDescriptions = [p.variableDescriptions, tb2.props.variableDescriptions];
    p.variableUnits = [p.variableUnits, tb2.props.variableUnits];

    out = mlist(["table", "props", "vars"], p, data);
endfunction
