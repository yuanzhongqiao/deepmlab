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

function out = %table_f_table(tb1, tb2)
    fname = "%table_f_table";
    varNames_tb1 = tb1.props.variableNames;
    varNames_tb2 = tb2.props.variableNames;
    rowNames_tb1 = tb1.props.rowNames;
    rowNames_tb2 = tb2.props.rowNames;
    rowNames = [];

    if size(varNames_tb1, "*") <> size(varNames_tb2, "*") then
        error(msprintf(_("%s: All tables must have the same number of variableNames.\n"), fname));
    end

    if or(varNames_tb1 <> varNames_tb2) then
        error(msprintf(_("%s: All tables must have the same variableNames.\n"), fname));
    end

    if rowNames_tb1 == [] && rowNames_tb2 <> [] then
        rowNames = ["Row" + string(1:size(tb1, 1))'; rowNames_tb2];
    elseif rowNames_tb1 <> [] && rowNames_tb2 == [] then
        s = size(rowNames_tb1, 1);
        rowNames = [rowNames_tb1; "Row" + string(s+1:s+size(tb2, 1))'];
    else
        rowNames = [rowNames_tb1;  rowNames_tb2];
    end

    out = tb1;
    for c = 1:size(tb1.vars, "*")
        d1 = tb1.vars(c).data;
        d2 = tb2.vars(c).data;
        if typeof(d1) <> typeof(d2) then
            error(msprintf(_("%s: Impossible to concatenate ""%s"" column: Same types expected but got ""%s"" and ""%s""."), fname, varNames_tb1(c), typeof(d1), typeof(d2)));
        end
        out.vars(c).data = [tb1.vars(c).data; tb2.vars(c).data];
    end
 
    out.props.rowNames = rowNames;
endfunction
