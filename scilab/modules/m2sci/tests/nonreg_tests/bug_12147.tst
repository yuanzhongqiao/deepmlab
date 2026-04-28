// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12147 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12147
//
// <-- Short Description -->
//  1) .mat files ending with "end" closing the "function" statement
//     could not be converted
//  2) When the function name matched a variable existing in the
//     environment, mfile2sci() yielded an error.

f = ["function y = f(x)"
     "  y = x;"
     "end"];
path = TMPDIR+"/f.m";
mputl(f, path);
assert_checkequal(mfile2sci(path,TMPDIR),1);
mdelete(path);
