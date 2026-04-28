// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function t = struct2table(st, varargin)
    fname = "struct2table";

    if ~isstruct(st) then
        error(msprintf(_("%s: Wrong type for input argument #%d: struct expected.\n"), fname, 1));
    end

    asarray = size(st, "*") <> 1;
    rhs = nargin - 1;

    if rhs > 1 then
        for i = rhs-1:-2:1
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end

            select convstr(varargin(i), "l")
            case "asarray"
                asarray = varargin(i+1);
                if type(asarray) <> 4 then
                    error(msprintf(_("%s: Wrong type for %s argument: a boolean expected.\n"), fname, sci2exp(varargin(i))));
                end
                
                if ~isscalar(asarray) then
                    error(msprintf(_("%s: Wrong type for %s argument: a boolean expected.\n"), fname, sci2exp(varargin(i))));
                end
                varargin(i+1) = null();
                varargin(i) = null();
            end
        end
    end

    if asarray then
        names = fieldnames(st)';
        if size(st, "*") == 1 then
            for f = names
                value = st(f);
                if ~isscalar(value) then
                    st(f) = {value};
                end
            end
        else
            rows = size(st, "*");
            for f = names
                inCell = %f;
                value = st(f);
                v = value(1);
                typ = typeof(v);
                s = size(v);
                if and(s == [0 0]) then
                    inCell = %t;
                end

                for i = 2:size(value)
                    v = value(i);
                    if typeof(v) <> typ then
                        error(msprintf(_("%s: Wrong type for %s fieldname: same type for each field expected.\n"), "struct2table", f));
                    end

                    if inCell then
                        continue
                    end

                    si = size(v);
                    if or(si <> s) | si(1) <> 1 then
                        inCell = %t;
                        continue
                    end
                end
                if inCell then
                    for i = 1:rows
                        st(i)(f) = {st(i)(f)};
                    end
                end
            end
        end

    end

    t = table(st, varargin(:));
endfunction
