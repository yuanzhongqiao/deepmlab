// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 15642 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15642
//
// <-- Short Description -->
// A(:) gives incorrect display when A is sparse boolean (regression)

A=sparse([1 1; 2 2; 3 3],[%t %f %t],[3 3]);
A(:)
