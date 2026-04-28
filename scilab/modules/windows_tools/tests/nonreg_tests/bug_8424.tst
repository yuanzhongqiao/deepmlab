// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- JVM MANDATORY -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8424 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8424
//
// <-- Short Description -->
// [a, b] = dos("git 1>&2") returned a wrong error.
//
// git without parameter returns same thing git --help.
// except that it is in stderr and not in stdout
// Here dos failed and returned [] and a error in api_scilab.

[stat, _, stderr] = host("git 1>&2");
assert_checkequal(stat, 1);

[stat, stdout, _] = host("git --help");
assert_checkequal(stat, 0);

assert_checkequal(stderr, stdout);
