// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17029 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17029
//
// <-- Short Description -->
// getfield() requires an output argument, it cannot be used with `ans` display

assert_checkequal(getfield(1,struct()),["st","dims"]);
assert_checkequal(getfield(1,list(1,2,3)),1)