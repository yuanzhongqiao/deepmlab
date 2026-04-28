// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function tree = sci_complex(tree)
    // M2SCI conerter for Matlab iscomplex()

    [A, B] = getrhs(tree);
    A = convert2double(A);
    B = convert2double(B);
    tree.rhs = Rhs_tlist(A, B);

    for i = 1:size(size(A), "*") 
        if A.dims(i) > B.dims(i) then
            tree.lhs(1).dims(i) = A.dims(i);
        else
            tree.lhs(1).dims(i) = B.dims(i);
        end
    end
    tree.lhs(1).dims = A.dims;
    tree.lhs(1).type = Type(Double,Complex)
endfunction
