// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17011 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17011
//
// <-- Short Description -->
// Matplot crash because of missing `rect` input argument.

msg=msprintf(_("%s: Wrong value for input argument #%d or missing ''%s'' argument.\n"), "Matplot", 2, "rect");
assert_checkerror("Matplot(1:10, ""010"")", msg);