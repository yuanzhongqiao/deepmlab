// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = removevars(in, vars)
    arguments
        in {mustBeA(in, ["table", "timeseries"])}
        vars {mustBeA(vars, ["double", "boolean", "string", "cell"]), mustBeVector}
    end

    out = in;
    select typeof(vars)
    case "constant"
        s = 1:size(in, 2);
        m = members(vars, s);
        if or(m == 0) then
            error(msprintf(_("%s: Wrong value for input argument #%d: A valid column index expected.\n"), "removevars", 2));
        end

    case "boolean"
        s = size(in, 2);
        if size(vars, "*") > s then
            error(msprintf(_("%s: Wrong size for input argument #%d: 1 x %d size expected.\n"), "removevars", 2, s));
        end

    case "string"
        varnames = in.props.variableNames;
        m = members(vars, varnames)
        if or(m == 0) then
            error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "removevars", 2));
        end

    case "ce"
        varnames = in.props.variableNames;
        for i = 1:size(vars, "*")
            idx = vars{i};
            if type(idx) <> 10 then
                error(msprintf(_("%s: Wrong type for input argument #%d: A cell containing strings expected.\n"), "removevars", 2));
            end
            m = members(idx, varnames);
            if or(m == 0) then
                error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "removevars", 2));
            end
        end
    end

    out(:, vars) = [];

endfunction