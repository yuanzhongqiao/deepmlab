// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [y, d] = polyval(p, x, S, mu)
    arguments
        p {mustBeA(p, ["double", "polynomial"])}
        x {mustBeA(x, "double")}
        S {mustBeA(S, ["double", "struct"])} = []
        mu {mustBeA(mu, "double"), mustBeVector} = [0 1]
    end

    if nargout == 2 && (nargin < 3 || isempty(S)) then
        error(msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), "polyval", 3));
    end

    if type(p) == 2 then
        p = coeff(p)($:-1:1);
    end

    if size(p, 1) > 1 && size(p, 2) > 1 then
        error(msprintf(_("%s: Wrong size for input argument #%d: a vector expected.\n"), "polyval", 1));
    end

    if isempty(p) || isempty(x) then
        y = zeros(x);
        return
    end

    if typeof(S) == "st" then
        fieldsExpected = ["R"; "df"; "normr"];
        fieldS = fieldnames(S);
        if or(members(fieldsExpected, fieldS) == 0) then
            error(msprintf(_("%s: Wrong field in the structure.\n"), "polyval"));
        end
    elseif S <> [] then
        if nargout == 1 && nargin > 2 then
            y = p;
            return
        else
            error(msprintf(_("%s: Wrong type for input argument #%d: a structure expected.\n"), "polyval", 3))
        end
    end

    if nargin == 4 then
        if size(mu, "*") == 1 then
            error(msprintf(_("%s: Wrong type for input argument #%d: a vector expected.\n"), "polyval", 4));
        end

        x = (x - mu(1)) / mu(2);
    end

    y = p(1) * ones(x);
    for i = 2:length(p)
        y = x .* y + p(i);
    end

    if nargout == 2 then
        R = S.R;
        df = S.df;
        normr = S.normr;

        v = vander(x(:), length(p));
        v = v(:, $:-1:1);
        E = v/R;
        d = sqrt(1 + sum(E .* E, 2)) * normr / sqrt(df);
        d = matrix(d, size(x))
    end

endfunction
