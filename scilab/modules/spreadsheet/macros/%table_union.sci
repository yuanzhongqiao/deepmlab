// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [out, ka, kb] = %table_union(t1, t2)
    [rows1, nbvars1] = size(t1);
    [rows2, nbvars2] = size(t2);

    if nbvars1 <> nbvars2 then
        error(msprintf(_("%s: Wrong size for input argument #%d: Must have the same number of variables as #%d.\n"), "union", 2, 1));
    end

    [nb, loc] = members(t1.props.variableNames, t2.props.variableNames);

    if or(nb == 0) then
        error(msprintf(_("%s: Wrong size for input argument #%d: Must have the same variables as #%d.\n"), "union", 2, 1));
    end

    mat = zeros(rows1+rows2, nbvars1);
    for i = 1:nbvars1
        a = t1.vars(i).data;
        b = t2.vars(loc(i)).data;
        [_,_,l] = unique([a;b]);

        mat(:,i) = l;      
    end

    kab = [1:rows1, -(1:rows2)]
    [_,k] = unique(mat,"r");
    out = [t1; t2(:, loc)](k, :)
    kab = kab(k)
    ka = kab(kab>0)
    kb = -kab(kab<0)

endfunction