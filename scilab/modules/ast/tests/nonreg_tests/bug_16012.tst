// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16012 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16012
//
// <-- Short Description -->
//  [struct() struct()] crashes scilab

assert_checkequal([struct() struct()],struct())
