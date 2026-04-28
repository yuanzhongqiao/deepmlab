// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [p, s, mu] = polyfit(x, y, n, w)
    arguments
        x {mustBeA(x, "double")}
        y {mustBeA(y, "double")}
        n (1,1) {mustBeA(n, ["double", "polynomial"])}
        w {mustBeA(w, "double")} = ones(x)
    end

    if size(x, "*") <> size(y, "*") then
        error(msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2));
    end

    typ = typeof(n);
    if typ == "constant" then
        if n <> floor(n) then
            error(msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "polyfit", 3));
        end
        if n < 0 then
            error(msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "polyfit", 3));
        end
    else
        if sum(coeff(n)) <> 1 then
            error(msprintf(_("%s: Wrong value for input argument #%d: Must be of the form X^n.\n"), "polyfit", 3));
        end
        n = degree(n);
    end

    hasWeight = nargin == 4;
    if hasWeight then
        if size(x, "*") <> size(w, "*") then
            error(msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 4));
        end
    end    

    if nargout == 3 then
        mu = [mean(x), stdev(x)];
        x = (x - mu(1)) / mu(2);
    end

    x = x(:);
    y = y(:);
    
    if (n >= length(x)) then
        warning(msprintf(_("%s: The solution is not unique because the argument #%d n >= number of data points.\n"), "polyfit", 3));
    end
    
    v = vander(x, n+1);
    v = v(:, $:-1:1);
    if hasWeight then
        w = w(:);
        y = y .* w;
        v = v .* (w .*. ones(1, n+1));
    end

    [Q, R, P] = qr(v, "e");
    p = R \ (Q' * y);
    p = P * p;
    
    if nargout > 1 then
        s.R = R * P;
        s.df = max(0, size(x, "*") - (n + 1));
        s.normr = norm(y - v * p)
    end

    p = p.';
    if typ == "polynomial" then
        p = poly(p($:-1:1), "x", "coeff");
    end

endfunction
