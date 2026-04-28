// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [X, Y, Z] = peaks(x, y)
    arguments
        x {mustBeA(x, "double"), mustBeReal} = 49
        y {mustBeA(y, "double"), mustBeReal} = []
    end

    rhs = argn(2)

    if rhs == 0 then
        X = linspace (-3, 3, x);
        Y = linspace (-3, 3, x);
    elseif rhs == 1 then
        if isscalar(x) then // peaks(n)
            if x <= 0 then
                error(msprintf(_("%s: Wrong value for input argument #%d: Must be greater than %d.\n"), "peaks", 1, 0));
            end
            X = linspace (-3, 3, x);
            Y = linspace (-3, 3, x);
        elseif isvector(x) then // peaks(x))
            X = x;
            Y = x;
        else
            error(msprintf(_("%s: Wrong size for input argument #%d: Must be a scalar or a vector.\n"), "peaks", 1));
        end
    else // peaks(x, y)
        X = x;
        Y = y;
    end

    if isvector(X) & isvector(Y) then
        sizeX = size(X, "*");
        sizeY = size(Y, "*");
        X = (X(:) .*. ones(1, sizeY))';
        Y = (Y(:)' .*. ones(sizeX, 1))';
    else
        X = x;
        Y = y;
    end

    Z = 3 * (1 - X) .^ 2 .* exp(-(X .^ 2) - (Y + 1) .^2) ...
      -10 * (X / 5 - X .^ 3 - Y .^ 5) .* exp(-X .^ 2 - Y .^ 2) ...
      -1 / 3 * exp(-(X + 1) .^ 2 - Y .^ 2);
      
    if argn(1) == 1 then
        X = Z;
    end
endfunction
