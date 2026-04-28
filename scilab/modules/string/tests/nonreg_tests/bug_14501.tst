// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - ESI Group - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14501 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14501
//
// <-- Short Description -->
// strsubst crashed on consecutive occurrences.
// -------------------------------------------------------------
assert_checkequal(strsubst("faaaf","aa","a"), "faaf");
assert_checkequal(strsubst("faaaaaaaaf","aa","a"), "faaaaf");

