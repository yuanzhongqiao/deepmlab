// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [tout, idx] = sortrows(tin, varargin)

    arguments
        tin {mustBeA(tin, ["double", "string", "boolean", "integer", "duration", "datetime", "table", "timeseries"])}
        varargin
    end

    t = tin;
    direction = "i";

    if istimeseries(t) then
        t = timeseries2table(t);
    end

    isTable = istable(t);

    if nargin >= 2 then
        vars = varargin(1);
        if isTable then
            names = t.props.variableNames;
            s = size(t, 2);
            typ = ["constant", "boolean", "string", "ce"];
            if and(typeof(vars) <> typ) then
                error(msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sortrows", 2, typ));
            end

            select typeof(vars)
            case "string"
                if convstr(vars, "l") == "rownames" then
                    [g, idx] = gsort(t.Row, "g", "i");
                    tout = t(idx, :);
                    return
                end
                
                index = or(members(vars, names) == 0);
                if index then
                    error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "sortrows", 2));
                end

            case "constant"
                index = or(members(vars, 1:s) == 0);
                if index then
                    error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "sortrows", 2));
                end

                if vars <> int(vars) then
                error(msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "sortrows", 2));
                end

                if or(vars == 0) then
                    error(msprintf(_("%s: Wrong value for input argument #%d: Zero are not allowed.\n"), "sortrows", 2));
                end

                if or(vars < 0) then
                    direction = "i" + emptystr(vars);
                    direction(vars < 0) = "d";
                    vars = abs(vars);
                end

            case "ce"
                for i = 1:size(vars, "*")
                    if type(vars{i}) <> 10 then
                        error(msprintf(_("%s: Wrong type for input argument #%d: A cell containing strings expected.\n"), "sortrows", 2));
                    end
                    if and(vars{i} <> names) then
                        error(msprintf(_("%s: Wrong value for input argument #%d: A valid variable name expected.\n"), "sortrows", 2));
                    end
                end

            case "boolean"
                if size(vars, "*") > s then
                    error(msprintf(_("%s: Wrong size for input argument #%d: 1 x %d size expected.\n"), "sortrows", 2, s));
                end
            end
        else
            // matrix
            if type(vars) <> 1 then
                error(msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sortrows", 2, sci2exp("double")));
            end
            if vars <> int(vars) then
                error(msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "sortrows", 2));
            end
            if or(vars == 0) then
                error(msprintf(_("%s: Wrong value for input argument #%d: Zero are not allowed.\n"), "sortrows", 2));
            end

            if or(vars < 0) then
                direction = "i" + emptystr(vars);
                direction(vars < 0) = "d";
                vars = abs(vars);
            end
        end
        t = t(:, vars);
    end

    if nargin == 3 then
        direction = varargin(2);
        typ = ["string", "ce"];
        if and(typeof(direction) <> typ) then
            error(msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sortrows", 3, typ));
        end

        siz_direction = size(direction, "*");
        s = size(vars, "*");

        if siz_direction <> 1 & siz_direction <> s then
            error(msprintf(_("%s: Wrong size for input argument #%d: Must be of the same dimensions of #%d.\n"), "sortrows", 3, s));
        end

        select typeof(direction)
        case "string"
            if or(members(direction, ["i", "d", "ascend", "descend"]) == 0) then
                error(msprintf(_("%s: Wrong value for input argument #%d: Must be in %s.\n"), "sortrows", 3, sci2exp(["i", "d", "ascend", "descend"])));
            end

        case "ce"
            d = [];
            for i = 1:siz_direction
                d(i) = direction{i}
                if and(d(i) <> ["i", "d", "ascend", "descend"]) then
                    error(msprintf(_("%s: Wrong value for input argument #%d: Must be in %s.\n"), "sortrows", 3, sci2exp(["i", "d", "ascend", "descend"])));
                end
            end
            direction = d;
            
        end
        direction(direction == "ascend") = "i";
        direction(direction == "descend") = "d";
    end

    [rows, cols] = size(t);

    if isscalar(direction) then
        if isTable then
            v = zeros(rows, cols);
            for i = 1:cols
                [u, k, v(:,i), nb] = unique(t.vars(i).data);
            end
            [g, idx] = gsort(v, "lr", direction);
        else
            [g, idx] = gsort(t, "lr", direction);
        end
    else
        idx = (1:rows)';
        for i = cols:-1:1
            [g, j] = gsort(t(idx, i), "g", direction(i));
            idx = idx(j);
        end
    end

    tout = tin(idx, :);
    
endfunction
