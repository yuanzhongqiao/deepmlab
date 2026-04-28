//------------------------------------------------------------------------------------------------------------
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA - Pierre MARECHAL
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//
// Returns the last day of the year and month by corresponding element of Matrix Y and M
//------------------------------------------------------------------------------------------------------------

function E = eomday(Y, M)

    arguments
        Y {mustBeA(Y, "double"), mustBeReal, mustBeInteger}
        M {mustBeA(M, "double"), mustBeReal, mustBeInteger, mustBeEqualDims(M, Y), mustBeInRange(M, 1, 12)}
    end

    common_year = [31,28,31,30,31,30,31,31,30,31,30,31];
    leap_year   = [31,29,31,30,31,30,31,31,30,31,30,31];

    [nr,nc] = size(M);
    E = zeros(1, nr*nc);
    isleapyear = isLeapYear(Y);
    E(isleapyear) = leap_year(M(isleapyear));
    E(~isleapyear) = common_year(M(~isleapyear));
    E = matrix(E,nr,nc);

endfunction
