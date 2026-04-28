//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 296 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/296
//
// <-- Short Description -->
//     


if ([1+2*%i].*.[1])<>([1].*.[1+2*%i]) then pause,end
