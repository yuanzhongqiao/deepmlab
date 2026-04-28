//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4618 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4618
//
// <-- Short Description -->
// buttmag produces a warning because of redefining symbol sample.

if buttmag(3,1000,1)<>1 then pause,end
