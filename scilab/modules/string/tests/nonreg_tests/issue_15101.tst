// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15101 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15101
//
// <-- Short Description -->
// ascii() stops before null character when converting to string. A warning is 
// issued when the input contains null characters.
//

// Expected output: "Hello"
// display a warning about null character at index 6
str = ascii([72 101 108 108 111 0 87 111 114 108 100])
assert_checkequal(str, "Hello");
