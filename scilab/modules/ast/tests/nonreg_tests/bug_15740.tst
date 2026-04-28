// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15740 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15740
//
// <-- Short Description -->
// %s == %z now returns %T and %s ~= %z returns %F  (Regressions)

assert_checkfalse(%s == %z)
assert_checktrue(%s ~= %z)