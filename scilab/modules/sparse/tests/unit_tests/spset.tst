// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.
//

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

sp = sprand(10000, 20000, 0.01);
[ij,v]=spget(sp);
n = nnz(sp);

spset(sp, 1:n);
[ij2,v2]=spget(sp);
assert_checkequal(ij, ij2);
assert_checkequal(v2', 1:n);
