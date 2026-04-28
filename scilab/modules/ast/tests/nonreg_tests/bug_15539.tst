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
// <-- Non-regression test for bug 15539 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15539
//
// <-- Short Description -->
// Zero step in integer implicit list crashes scilab

assert_checkequal(uint8(0):0:1,[]);
