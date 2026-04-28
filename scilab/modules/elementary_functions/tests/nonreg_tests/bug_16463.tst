// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16463 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16463
//
// <-- Short Description -->
// matrix(sparse([]), [0 0]) returns [] instead of sparse([])

ef = [];
esp = sparse([]);
espb = (esp>0)([]);

assert_checkequal(matrix(ef, [0 0]),ef);
assert_checkequal(matrix(esp, [0 0]),esp);
assert_checkequal(matrix(espb, [0 0]),espb);
