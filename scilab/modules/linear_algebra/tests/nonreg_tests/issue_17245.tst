// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17245 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17245
//
// <-- Short Description -->
// SCHUR function returns incorrect results when transforming complex-valued matrix pencils

A = [1 2; 3 4] + %i*ones(2,2);
B = [-1 1; 2 -1];
[AA, BB, Q, Z] = schur( A, B );
assert_checktrue(isreal(BB) == %F);

[a, b, c, d] = schur(1, %i);
assert_checkequal(a, -%i);
assert_checkequal(b, 1+ 0 * %i);
assert_checkequal(c, -%i);
assert_checkequal(d, -1+ 0 * %i);

[a, b, c, d] = schur(%i, 1);
assert_checkequal(a, %i);
assert_checkequal(b, 1+ 0 * %i);
assert_checkequal(c, 1+ 0 * %i);
assert_checkequal(d, 1+ 0 * %i);

