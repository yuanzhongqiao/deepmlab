// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Scilab Enterprises - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- INTERACTIVE TEST -->
// <-- Non-regression test for bug 14424 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14424
//
// <-- Short Description -->
// input: remove size max of input function, avoid wrong interpretation of C characters ('\', '%', ...)

//length test
x1 = input("01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789: ");
18
disp(x1)
