// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function p = pascal(n, k)
    arguments
        n {mustBeA(n, "double"), mustBeScalarOrEmpty, mustBeNonnegative}
        k {mustBeA(k, "double"), mustBeScalarOrEmpty, mustBeMember(k, [0 1 2])} = 0
    end

    p = %_gallery("pascal", n, k);

    if k == 2 then
        p = flipdim(p, 1)';
        if modulo(n, 2) == 0 then
            p = -p;
        end
    end
endfunction
