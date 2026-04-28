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
// <-- Non-regression test for bug 15531 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15531
//
// <-- Short Description -->
// [x,k]=gsort(%nan+ones(n,1)) crashes Scilab for a large enough n

[x,k]=gsort(%nan+ones(1000,1));