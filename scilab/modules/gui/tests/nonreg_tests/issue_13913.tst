// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 13913 -->
//
// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13913
//
// <-- Short Description -->
// The second output argument of xgetmouse always returned 0.

scf(2);
val = -1;
while val == -1, 
    [rep, win]=xgetmouse([%t %t]);
    [rep, win]
    val = rep(3);
end

// Move your mouse in window
// Check that the "win" value is equal to 2
// Click in the window to exit the loop