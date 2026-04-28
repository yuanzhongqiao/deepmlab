// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16474 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16474
//
// <-- Short Description -->
// imult(%z) crashes Scilab 

assert_checkequal(imult(%i+%s),-1+%i*%s)