// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17356 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17356
//
// <-- Short Description -->
// getfield() crash with struct

s.r = %pi
msg = msprintf(_("%s: Field ""%ls"" does not exist\n"), "getfield", "Scilab");
assert_checkerror("isfield = getfield(""Scilab"", s)",msg);
s.Scilab = %t;
assert_checktrue(getfield("Scilab", s));
