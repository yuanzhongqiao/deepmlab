// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [x, y, z] = cylinder(r, n)
    arguments
        r {mustBeA(r, "double"), mustBeVector, mustBeReal, mustBeNonnegative} = 1
        n {mustBeA(n, "double"), mustBeReal, mustBeScalar, mustBeNonnegative} = 20
    end
    
    if isscalar(r) then
        r = r .* [1 1];
    end

    [phi, idx] = meshgrid(linspace(0, 2*%pi, n+1), 1:size(r, "*"));

    z = (idx - 1) / (size(r, "*") - 1);
    r = r(idx);
    [x, y] = pol2cart(phi, r);
endfunction