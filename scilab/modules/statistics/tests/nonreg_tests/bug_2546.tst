//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2546 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2546
//
// <-- Short Description -->
// median(matrix,'c') errors when matrix contains exactly one row.

if abs(median([1, 2, 3], 'c')-2)>%eps then pause,end
