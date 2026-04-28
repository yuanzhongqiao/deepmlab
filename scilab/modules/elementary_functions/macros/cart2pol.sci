// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [theta, rho, z] = cart2pol(x, y, z)
    arguments
        x {mustBeA(x, "double"), mustBeReal, mustBeEqualDims(x, y)}
        y {mustBeA(y, "double"), mustBeReal}
        z {mustBeA(z, "double"), mustBeReal} = []
    end
    
    if nargin == 3 then
        if or(size(z) <> size(x)) then
            if isscalar(z) then
                z = ones(x) * z;
            else
                error(msprintf(_("%s: Wrong size for input argument #%d: Must be a scalar or be of the same dimensions as #%d.\n"), "cart2pol", 3, 1));
            end
        end
    end

    theta = atan(y, x);
    rho = sqrt(x .^ 2 + y .^ 2);

endfunction
