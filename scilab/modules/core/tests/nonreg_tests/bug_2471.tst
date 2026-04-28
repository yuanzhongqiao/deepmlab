//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2471 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2471
//
// <-- Short Description -->
//   try and evstr do not work together

clear x;try;evstr("x>5");end