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
// <-- Non-regression test for bug 15774 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15774
//
// <-- Short Description -->
// clean() fails on sparse complex matrix

assert_checkequal(clean(sparse(%i*[1 %eps])),sparse([%i 0]))