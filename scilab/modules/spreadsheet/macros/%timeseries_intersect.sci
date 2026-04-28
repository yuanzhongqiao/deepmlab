// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [out, ka, kb] = %timeseries_intersect(ts1, ts2)
    out = [];
    [rows1, nbvars1] = size(ts1);
    [rows2, nbvars2] = size(ts2);

    if nbvars1 <> nbvars2 then
        error(msprintf(_("%s: Wrong size for input argument #%d: Must have the same number of variables as #%d.\n"), "intersect", 2, 1));
    end

    [nb, loc] = members(ts1.props.variableNames, ts2.props.variableNames);

    if or(nb == 0) then
        error(msprintf(_("%s: Wrong size for input argument #%d: Must have the same variables as #%d.\n"), "intersect", 2, 1));
    end

    matidxA = zeros(rows1, nbvars1+1);
    matidxB = zeros(rows2, nbvars1+1);
    for i = 1:nbvars1+1
        a = ts1.vars(i).data;
        b  = ts2.vars(loc(i)).data;
        [_,_,l] = unique([a;b]);

        matidxA(:,i) = l(1:rows1);
        matidxB(:,i) = l(rows1+1:$);      
    end

    [c, ka, kb] = intersect(matidxA, matidxB, "r");
    if ka <> [] then
        out = ts1(ka, :);
    end

endfunction
