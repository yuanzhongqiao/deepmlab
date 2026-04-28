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

function out = %table_e(varargin)
    out = [];

    if nargin == 2 then
        if type(varargin(1)) == 10 then
            i = varargin(1);
            t = varargin(2);
            select i
            case "Properties"
                out = t.props;

            case "Variables"
                for i = 1:size(t.vars, "*")
                    out = [out t.vars(i).data];
                end
            case "Row"
                out = t.props.rowNames;
            else
                [tmp, idx] = members(i, t.props.variableNames);
                if or(idx <> 0) then
                    for i = idx
                        if out <> [] && typeof(out) <> typeof(t.vars(i).data) then
                            error(msprintf(_("Different data types.\n")));
                        end
                        out = [out t.vars(i).data];
                    end
                else
                    error(msprintf(_("A valid variable name expected.\n")));
                end
            end
        elseif or(type(varargin(1)) == [1 2 4 129]) then
            // double, polynom ($), boolean, implicist list (1:1:$)
            t = varargin($);
            out = t(varargin(1), :);
        end
    
    // 3 arguments t(1, 1), t(rowname, colname)...
    else
        i = varargin(1);
        j = varargin(2);
        t = varargin(3);

        select typeof(i)
        case "constant"
            if or(i > size(t, 1)) then
                error(msprintf(_("Extraction not possible.\n")));
            end
        case "string"
            rowNames = t.props.rowNames;
            [xxx, k] = members(i, rowNames);
            if or(k == 0) then
                error(msprintf(_("A valid row name expected.\n")));
            end
            i = k
        case "ce"
            rowNames = t.props.rowNames;
            tmp = [];
            for c = 1:size(i, "*")
                [xxx, k] = members(i{c}, rowNames);
                if and(k == 0) then
                    error(msprintf(_("A valid row name expected.\n")));
                end
                tmp = [tmp, k];
            end
            i = tmp;
        end

        select typeof(j)
        case "constant"
            if or(j > size(t, 2)) then
                error(msprintf(_("Extraction not possible.\n")));
            end
        case "string"
            names = t.props.variableNames;
            [xxx, j] = members(j, names);
            if or(j == 0) then
                error(msprintf(_("A valid variable name expected.\n")));
            end
        case "ce"
            names = t.props.variableNames;
            tmp = [];
            for c = 1:size(j, "*")
                [xxx, k] = members(j{c}, names);
                if and(k == 0) then
                    error(msprintf(_("A valid variable name expected.\n")));
                end
                tmp = [tmp, k];
            end
            j = tmp;
        end

        out = t;
        out.vars = out.vars(1, j);
        for c = 1:size(out.vars, "*")
            out.vars(c).data = out.vars(c).data(i);
        end
        
        //update props
        for f = fieldnames(out.props)'
            if f == "userdata" then
                out.props(f) = [];
                continue;
            elseif f == "rowNames" then
                if out.props(f) <> [] then
                    out.props(f) = out.props(f)(i);
                end
            else
                if size(out.props(f), "*") == 1 then
                    out.props(f) = out.props(f)(1);
                else
                    out.props(f) = out.props(f)(1, j);
                end
            end
        end
    end
endfunction
