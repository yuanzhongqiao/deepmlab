// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17152 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17152
//
// <-- Short Description -->
// clean function uses max(abs(A)) for relative tolerance.
// update clean help page to accord function and doc

A = [1 2;3 4];

epsAbs = 1;
epsRel = 0.3;

Ac = clean(A, epsAbs);
assert_checkequal(Ac, [0 2; 3 4]);

Ac = clean(A, epsAbs, epsRel);
assert_checkequal(Ac, [0 2; 3 4]);
