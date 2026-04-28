// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %timeseries_c_table(ts, t)

    names = [ts.props.variableNames, t.props.variableNames];
    unames = unique(names);
    if size(names, "*") <> size(unames, "*") then
        error(msprintf(_("%s: names in VariableNames must be different.\n"), "%timeseries_c_table"));
    end

    tt = ts.vars;
    tt = [tt t.vars];

    p = ts.props;
    p.variableNames = [p.variableNames, t.props.variableNames];
    p.variableDescriptions = [p.variableDescriptions, t.props.variableDescriptions];
    p.variableUnits = [p.variableUnits, t.props.variableUnits];
    p.variableContinuity = [p.variableContinuity, emptystr(1, size(t, 2))];

    out = mlist(["timeseries", "props", "vars"], p, tt);
    
endfunction