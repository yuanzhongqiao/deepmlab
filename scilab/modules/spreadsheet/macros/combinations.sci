// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function out = combinations(varargin)

    fname = "combinations";
    if nargin == 0 then
        error(msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), fname, 1));
    end

    in = list();
    typ = ["constant", "boolean", "string", "datetime", "duration"];
    for i = 1:nargin
        v = varargin(i);
        if and(typeof(v) <> typ) then
            error(msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), fname, i, sci2exp(typ)));
        end
        in(i) = v(:);
    end

    c = %_combinations(in);
    out = table(c(:));
endfunction

