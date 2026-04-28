// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17272 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17272
//
// <-- Short Description -->
// datetime("1999-06", "InputFormat", "yyyy-MM") returned an error

d = datetime("1999-06", "InputFormat", "yyyy-MM");
assert_checkequal(string(d), "1999-06-01");