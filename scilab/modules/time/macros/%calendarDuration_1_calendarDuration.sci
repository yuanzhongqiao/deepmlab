// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %calendarDuration_1_calendarDuration(cd1, cd2)
    arguments
        cd1
        cd2 {mustBeEqualDimsOrScalar(cd2, cd1)}
    end

    y1 = cd1.y > cd2.y; //exclution
    y2 = cd1.y < cd2.y; //equal y

    m1 = cd1.m > cd2.m; //exclution
    m2 = cd1.m < cd2.m; //equal m

    d1 = cd1.d > cd2.d; //exclution
    d2 = cd1.d < cd2.d; //equal d

    t = cd1.t < cd2.t; //time compare

    out = ~y1 && (y2 || (~m1 && (m2 || ~d1 && (d2 || t))));
endfunction
