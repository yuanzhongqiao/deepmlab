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

function out = %datetime_1_datetime(dt1, dt2)
    arguments
        dt1
        dt2 {mustBeEqualDimsOrScalar(dt2, dt1)}
    end

    idx = isnat(dt1) | isnat(dt2);
    date_bool1 = dt1.date > dt2.date; //exclution
    date_bool2 = dt1.date < dt2.date; //equal date
    time_bool = dt1.time < dt2.time; //time compare

    out = ~date_bool1 & (date_bool2 | time_bool);
    out(idx) = %f;
endfunction
