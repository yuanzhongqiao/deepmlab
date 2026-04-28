// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [c, vindex] = %_combinations(in)
    // internal function

    c = list();
    vindex = list();
    s = []
    for k = 1:size(in)
        s = [s size(in(k), "*")];
    end

    for k = 1:size(in)
        v = in(k)
        // from ndgrid function
        ind = (ones(1, prod(s(1:k-1))) .*. (1:s(k)) .*. ones(1, prod(s(k+1:$))))';
        c(k) = v(ind);
        vindex(k) = ind;
    end
endfunction