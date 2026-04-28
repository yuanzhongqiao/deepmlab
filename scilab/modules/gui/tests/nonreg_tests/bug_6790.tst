// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 6790 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6790
//
// <-- Short Description -->
// toprint(nFigure): %F was returned while actually the figure is printed.

// To save some paper, this test is interactive

scf(0);
plot3d();
if toprint(0) <> %t then pause,end