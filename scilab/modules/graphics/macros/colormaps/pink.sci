// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Pierre MARECHAL <pierre.marechal@scilab.org>
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//pink colormap : Sepia tone on black and white images
function cmap = pink(n)

    arguments
        n (1,1) {mustBeA(n, "double"), mustBeReal, mustBeInteger, mustBeNonnegative} = %_GetDefaultColormapSize()
    end

    red_1   = (0:n-1)'/max(n-1,1);
    green_1 = (0:n-1)'/max(n-1,1);
    blue_1  = (0:n-1)'/max(n-1,1);

    n1 = fix(3/8*n);
    n2 = n1;
    n3 = n-(n1+n2);

    red_2   = [(1:n1)'/n1  ; ones(n2,1)  ; ones(n3,1)];
    green_2 = [zeros(n1,1) ; (1:n2)'/n2  ; ones(n3,1)];
    blue_2  = [zeros(n1,1) ; zeros(n2,1) ; (1:n3)'/(n3)];

    red   = sqrt((2*red_1   + red_2)  /3);
    green = sqrt((2*green_1 + green_2)/3);
    blue  = sqrt((2*blue_1  + blue_2) /3);

    cmap = [red green blue];

endfunction
