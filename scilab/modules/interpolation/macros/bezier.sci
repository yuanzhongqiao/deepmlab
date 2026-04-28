// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function z = bezier(p, t, w)

    arguments
        p (:, [2 3]) {mustBeA(p, "double")}
        t {mustBeA(t, "double")}
        w {mustBeA(w, "double"), mustBeVector} = ones(size(p,1), 1)
    end

    if size(t, "*") == 1 then
        t = linspace(0, 1, t);
    else
        if iscolumn(t) then
            t = t';
        end
    end

    if nargin == 3  then
        s = size(w, "*");
        if s <> size(p, "r") then
            error(msprintf(_("%s: Wrong size for input argument #%d: %d x 1 expected.\n", "bezier", 3, size(p, "r"))));
        end
        
        if isrow(w) then
            w = w';
        end

        w = w * ones(1, size(p, "c"));
    end

    n = size(p, "r") - 1;

    b = bernstein(n, t);

    if nargin == 2 then
        z = b * p;
    else
        z = (b * (w .* p))./(b * w);
    end
endfunction