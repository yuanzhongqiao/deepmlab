// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16593 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16593
//
// <-- Short Description -->
// After L = list(1,2); , for o = L(3:$), o, end crashes Scilab

L = list(1,2);
msg = msprintf(_("%s: Wrong number of output argument(s): %d expected.\n"), "for expression", 1);
assert_checkerror("for o = L(3:$), o, end", msg);
