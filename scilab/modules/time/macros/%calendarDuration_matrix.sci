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

function cd1 = %calendarDuration_matrix(cd1, varargin)
    cd1.y = matrix(cd1.y, varargin(:));
    cd1.m = matrix(cd1.m, varargin(:));
    cd1.d = matrix(cd1.d, varargin(:));
    cd1.t = matrix(cd1.t, varargin(:));
endfunction
