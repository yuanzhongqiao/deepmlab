// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 16114 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16114
//
// <-- Short Description -->
// libraryinfo() yields 0x0 matrix of strings for lib without macro

 assert_checktrue(isempty(libraryinfo("astlib")))