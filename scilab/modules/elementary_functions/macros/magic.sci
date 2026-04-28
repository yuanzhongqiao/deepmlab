// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function m = magic(n)
    arguments
        n {mustBeA(n, "double"), mustBeScalarOrEmpty, mustBeNonnegative}
    end
    m = %_gallery("magic", n);
endfunction
