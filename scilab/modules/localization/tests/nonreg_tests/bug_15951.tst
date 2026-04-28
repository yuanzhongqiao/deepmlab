// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- MACOSX ONLY -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15951 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15951
//
// <-- Short Description -->
// locale encoding is not detected under OSX

assert_checkequal(length("é"),1)

