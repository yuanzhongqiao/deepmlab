// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15629 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15629
//
// <-- Short Description -->
// int(1e20) yields -9.223D+18  (regression)

assert_checkequal(int(1e20),1e20);
assert_checkequal(int(1e20*(1+%i)),1e20*(1+%i));
assert_checkequal(int(1e20*(1+%s)),1e20*(1+%s));
assert_checkequal(int(1e20*[1+%s;1-%s]),1e20*[1+%s;1-%s]);
a=sparse([0 1e20]);
assert_checkequal(int(a),a);
assert_checkequal(int(a*(1+%i)),a*(1+%i));
