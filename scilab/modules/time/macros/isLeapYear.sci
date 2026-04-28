// =============================================================================
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

// Return True if year is a leap year, otherwise False

// Si l'année est divisible par 4 et non par 100 => Année bissextile
// Si l'année est divisible par 400 => Année bissextile
// =============================================================================

function res = isLeapYear(y)

    arguments
        y {mustBeA(y, "double")}
    end

    res = ((modulo(y, 100) <> 0) & (modulo(y, 4) == 0)) | (modulo(y, 400) == 0);

endfunction
