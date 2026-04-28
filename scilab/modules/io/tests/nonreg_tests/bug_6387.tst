// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 6387 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6387
//
// <-- Short Description -->
// 'dos' failed to execute very long command line and returns an msg error : line too long

// try as very long command as (example)

values = rand(1,500);
str_values = strcat(string(values), " ");
cmd = "echo "+ str_values;
[stat, out] = host(cmd);
assert_checkequal(out, str_values);