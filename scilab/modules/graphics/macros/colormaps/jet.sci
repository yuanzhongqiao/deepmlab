// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//   PURPOSE
//      to get the usual classic colormap which goes from
//      blue - lightblue - green - yellow - orange then red
//   AUTHOR
//      Bruno Pincon
//
function [cmap] = jet(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    if n==0 then
        cmap = [];
        return
    end

    r = [0.000 0.125 0.375 0.625 0.875 1.000 ; 0.000 0.000 0.000 1.000 1.000 0.500]
    g = [0.000 0.125 0.375 0.625 0.875 1.000 ; 0.000 0.000 1.000 1.000 0.000 0.000]
    b = [0.000 0.125 0.375 0.625 0.875 1.000 ; 0.500 1.000 1.000 0.000 0.000 0.000]

    d = 0.5/max(n,1);
    x = linspace(d,1-d, n)
    cmap = [ interpln(r, x);...
    interpln(g, x);...
    interpln(b, x) ]';
    cmap = min(1, max(0 , cmap))  // normaly not necessary
endfunction
