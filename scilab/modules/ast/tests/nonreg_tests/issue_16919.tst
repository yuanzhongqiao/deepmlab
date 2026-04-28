// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16919 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16919
//
// <-- Short Description -->
// MList overload extraction compatibility with scilab 5.5.2

t = tlist(["useruseruser","x"],0);
m = mlist(["useruseruser","x"],0);

function res = %useruser_e(i,x)
    res = "aa";
endfunction

assert_checkequal(t("a"), "aa");
assert_checkequal(m("a"), "aa");
