// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Manuel Juliachs
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 11124 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11124
//
// <-- Short Description -->
// Incorrect rendering with filled curves in logarithmic coordinates.
//

xload(SCI+"/modules/graphics/tests/nonreg_tests/bug_11124.scg");

// Check that the delimiting curve exactly matches the upper contour of the
// filled area (the area's second and third peaks were incorrectly truncated).

