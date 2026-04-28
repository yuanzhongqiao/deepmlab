// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16623 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16623
//
// <-- Short Description -->
// rand(2,2,2) ^ 2  now yields a wrong result instead of trying to call the %s_p_s overload for input hypermatrices

msg = [sprintf(_("Undefined operation for the given operands.\n")); sprintf(_("check or define function %s for overloading.\n"), "%s_t")];
assert_checkerror("rand(2,2,2)^2", msg)
