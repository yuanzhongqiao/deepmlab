// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 407 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/407
//
// <-- Short Description -->
// Polylines with thickness greater than 2 and with more than 1380
// points are not displayed

// should complain about strf (normally a strig of length 3).
gca().thickness = 2;
// check if the curve is displayed
plot(1:10000);



