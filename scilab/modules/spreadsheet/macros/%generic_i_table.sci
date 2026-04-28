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

function out = %generic_i_table(varargin)
    //disp("generic_i_table", varargin)
    fname = "%generic_i_table";
    out = varargin($);
    i = varargin(1);
    val = varargin($-1);

    if nargin == 3 then
        // t("varname") = val, t.varname = val
        if type(i) <> 10 then
            error(msprintf(_("Wrong type for input argument #%d: string expected.\n"), 1));
        end

        if istable(val) then
            if i == "Row" then
                error(mpsrintf(_("Wrong value for input argument #%d: string expected.\n"), 2));
            end

            in = val;

            for k = 1:size(i, "*")
                idx = find(out.props.variableNames == i(k));
                if idx == [] then
                    in.props.variableNames = i(k);
                    out = [out in];
                    return
                end
                if typeof(out.vars(idx).data) <> typeof(in.vars(k).data) then
                    error(msprintf(_("Same type expected.\n")));
                end
                if size(out.vars(idx).data) <> size(in.vars(k).data) then
                    error(msprintf(_("Same size expected.\n")));
                end
                out.vars(idx).data = in.vars(k).data
            end

        elseif iscell(val) then

            if i == "Row" then
                str = [];
                for k = 1:size(val, "*")
                    str = [str, val{k}]
                end
                out.props.rowNames = str;
                return
            else
                idx = find(out.props.variableNames == i);
                if idx == [] then
                    // add variable
                    in = cell2table(val);
                    in.props.variableNames = i;
                    out = [out in];
                    return
                end
                i = idx;
            end

            for k = 1:length(i)
                out.vars(i(k)).data = val{:, k};
            end
        else
        
            if i == "Row" then
                out.props.rowNames = val;
                return
            else
                idx = find(out.props.variableNames == i);
                if idx == [] then
                    // add variable
                    out = [out table(val, "VariableNames", i)];
                    return
                end
                i = idx;
            end

            if val == [] then
                out.vars(i) = val;
                out.props.variableNames(i) = val;
                out.props.variableDescriptions(i) = val;
                out.props.variableUnits(i) = val;
            else
                if size(val, "*") <> size(out.vars(i).data, "*") & typeof(out.vars(i).data) <> typeof(val) then
                    error(msprintf(_("%s: Same type expected.\n"), fname));
                end

                s = size(out.vars(i).data)
                if isscalar(val) then
                    val = repmat(val, s(1), s(2));
                end

                out.vars(i).data = val;
            end
        end

    else
        j = varargin(2);
        [r, c] = size(out);
        iIsImplicitlist = %f;
        jIsImplicitlist = %f;
        rownames = [];
        varnames = [];

        if typeof(i) == "ce" then
            str = [];
            for k = 1:size(i, "*")
                str = [str, i{k}]
            end
            i = str;
        end

        select typeof(i)
        case "string"
            rownames = out.props.rowNames;
            if rownames == [] then
                if r == 0 then
                    rownames = i;
                else
                    rownames = "Row" + string(1:r);
                    rownames = [rownames; i];
                end
                i = r + 1:r + size(i, "*")
            else
                [xxx, idx] = members(i, rownames);
                if and(idx == 0) then
                    rownames = [rownames; i];
                    i = r + 1:r + size(i, "*")
                else
                    i = idx;
                end
            end
        case "boolean"
            // if i contains only %f
            if ~or(i) then
                return
            end

            i = find(i);
        case "polynomial"
            i = coeff(i) * (r ^ [0:degree(i)]');
        case "implicitlist"
            // 1:1:$
            if type(i(1)) == 1 && sum(coeff(i(3))) == 1 then
                i = 1:r
            else
                // $:$+2
                // i(1) == $, $+1, ...
                if type(i(1)) == 2 then
                    k(1) = coeff(i(1)) * (r ^[0:degree(i(1))]');
                else
                    k(1) = i(1)
                end
                // same i(1)
                if type(i(3)) == 2 then
                    k(3) = coeff(i(3)) * (r ^[0:degree(i(3))]');
                else
                    k(3) = i(3)
                end
                   
                i = k(1):i(2):k(3);
            end
            iIsImplicitlist = %t;
        end

        if typeof(j) == "ce" then
            str = [];
            for k = 1:size(j, "*")
                str = [str, j{k}]
            end
            j = str;
        end

        select typeof(j)
        case "string"
            varnames = out.props.variableNames;
            [xxx, jdx] = members(j, varnames);
            if and(jdx == 0) then
                varnames = [varnames, j];
                j = c + 1:c + size(j, "*")
            else
                j = jdx;
            end
        case "boolean"
            // if i contains only %f
            if ~or(j) then
                return
            end

            j = find(j);
        case "polynomial"
            j = coeff(j) * (c ^ [0:degree(j)]');
        case "implicitlist"
            // 1:1:$
            if type(j(1)) == 1 && sum(coeff(j(3))) == 1 then
                j = 1:c
            else
                // $:$+2
                // j(1) == $, $+1, ...
                if type(j(1)) == 2 then
                    k(1) = coeff(j(1)) * (c ^[0:degree(j(1))]');
                else
                    k(1) = j(1)
                end
                // same j(1)
                if type(j(3)) == 2 then
                    k(3) = coeff(j(3)) * (c ^[0:degree(j(3))]');
                else
                    k(3) = j(3)
                end
                   
                j = k(1):j(2):k(3);
            end
            jIsImplicitlist = %t;
        end

        if val == [] then
            // pause
            // à gerer le cas où i et j sont hors spectre
            if ~iIsImplicitlist & ~jIsImplicitlist then
                error(msprintf(_("impossible insertion.\n")));
            end
            if iIsImplicitlist then
                if max(j) <= c then 
                    out.vars(j) = val;
                    out.props.variableNames(j) = val;
                    out.props.variableDescriptions(j) = val;
                    out.props.variableUnits(j) = val;
                    return
                else
                    error(msprintf(_("impossible insertion.\n")));
                end
            end
            if jIsImplicitlist then
                if max(i) <=r then
                    for k = 1:c
                        out.vars(1,k).data(i) = val;
                    end
                    out.props.rowNames(i) = val;
                    return
                else
                    error(msprintf(_("impossible insertion.\n")));
                end
            end
        end

        if istable(val) then
            // %table_i_table
            for k = 1:length(j)
                //disp(i, j(k))
                out.vars(j(k)).data(i) = val.vars(k).data
            end
            varnames = val.props.VariableNames(1:length(j));
        elseif iscell(val) then
            // %ce_i_table
            if (size(i, "*") <> 1 | size(j, "*") <> 1) & size(val, "*") == 1 then
                val = repmat(val, length(i), length(j));
            end

            for l = 1:length(j)
                for k = 1:length(i)
                    out.vars(1,j(l)).data(i(k)) = val{k, l};
                end
            end
        else
            // val is matrix of doubles, matrix of strings or matrix of booleans
            // val must be the same type of table
            if (size(i, "*") <> 1 | size(j, "*") <> 1) & isscalar(val) then
                val = repmat(val, length(i), length(j));
            elseif or(size(val) <> [length(i), length(j)]) then
                error(msprintf(_("impossible insertion.\n")));
            end

            for l = 1:length(j)
                out.vars(1, j(l)).data(i) = val(:, l);
            end
        end

        if max(i) > r then
            out.props.rowNames = rownames;
        end

        if max(j) > c then
            n = grep(varnames, "Var");
            if varnames == [] then
                varnames = "Var" + string(j);
            end
            if n <> [] then
                varnames(n) = "Var" + string(j(n));
            end
            [r, w] = grep(out.props.variableNames, varnames);
            if r <> [] then
                [u, ki, ko, nb] = unique(w);
                varnames(u) = varnames(u) + string(nb); //)"Var" + string(j(n<>0));
            end
            out.props.variableNames(1,j) = varnames;
            out.props.variableDescriptions(1,j) = emptystr(1, length(j));
            out.props.variableUnits(1,j) = emptystr(1, length(j));
        end
    end

endfunction
