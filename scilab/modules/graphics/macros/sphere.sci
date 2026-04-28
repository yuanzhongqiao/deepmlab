// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [x, y, z] = sphere(n)
    arguments
        n {mustBeA(n, "double"), mustBeReal, mustBeNonnegative} = 20
    end

    if size(n, "*") == 1 then
        n = n * ones(1,2);
    end

    if size(n, "*") <> 2 then
        error(msprintf(_("%s: Wrong size for input argument #%d: A scalar or a vector of size 1 x 2 expected.\n"), "sphere", 1));
    end

    theta = linspace(0, 2*%pi, n(1)+1);
    phi = linspace(-%pi/2, %pi/2, n(2)+1);
    
    x = cos(phi)' * cos(theta);
    y = cos(phi)' * sin(theta);
    z = sin(phi)' * ones(theta);
endfunction