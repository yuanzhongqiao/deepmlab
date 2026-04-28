// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [x, y, z] = pol2cart(theta, rho, z)
    arguments
        theta {mustBeA(theta, "double"), mustBeReal, mustBeEqualDims(theta, rho)}
        rho {mustBeA(rho, "double"), mustBeReal}
        z {mustBeA(z, "double"), mustBeReal} = []
    end
    
    if nargin == 3 then
        if or(size(z) <> size(rho)) then
            if isscalar(z) then
                z = ones(rho) * z;
            else
                error(msprintf(_("%s: Wrong size for input argument #%d: Must be a scalar or be of the same dimensions as #%d.\n"), "pol2cart", 3, 1));
            end
        end
    end

    x = rho .* cos(theta);
    y = rho .* sin(theta);

endfunction
