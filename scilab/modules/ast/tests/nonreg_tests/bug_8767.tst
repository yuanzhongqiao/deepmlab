// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 8767 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8767
//
// <-- Short Description -->
// %F & ~%F | %T & ~%F  was %F

assert_checktrue(%F & ~%F | %T & ~%F);
