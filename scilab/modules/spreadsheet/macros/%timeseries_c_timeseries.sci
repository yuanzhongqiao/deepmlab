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

function out = %timeseries_c_timeseries(ts1, ts2)
    if ts1(ts1.props.variableNames(1)) <> ts2(ts2.props.variableNames(1)) then
        error(msprintf(_("%s: Time name in VariableNames must have the same name.\n"), "%timeseries_c_timeseries"));
    end

    names = [ts1.props.variableNames(2:$), ts2.props.variableNames(2:$)];
    unames = unique(names);
    if size(names, "*") <> size(unames, "*") then
        error(msprintf(_("%s: names in VariableNames must be different.\n"), "%timeseries_c_timeseries"));
    end

    t = ts1.vars;
    t = [t ts2.vars(2:$)];

    p = ts1.props;
    p.variableNames = [p.variableNames, ts2.props.variableNames(2:$)];
    p.variableDescriptions = [p.variableDescriptions, ts2.props.variableDescriptions(2:$)];
    p.variableUnits = [p.variableUnits, ts2.props.variableUnits(2:$)];
    p.variableContinuity = [p.variableContinuity, ts2.props.variableContinuity(2:$)];

    out = mlist(["timeseries", "props", "vars"], p, t);
endfunction
