// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 4702 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4702
//
// <-- Short Description -->
// on some case, dos(cmd) does not return results

[stat, output] = host('ipconfig');
assert_checkequal(stat, 0);
assert_checkfalse(output == []);
