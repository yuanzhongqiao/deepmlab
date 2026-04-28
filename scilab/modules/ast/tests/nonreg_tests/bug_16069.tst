// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16069 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16069
//
// <-- Short Description -->
// [].figure_name crashes Scilab

msg = msprintf(gettext("Attempt to reference field of non-structure array.\n"));
assert_checkerror("[].figure_name", msg);
