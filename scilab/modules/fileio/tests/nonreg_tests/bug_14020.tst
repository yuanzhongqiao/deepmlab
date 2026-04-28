// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 14020 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14020
//
// <-- Short Description -->
// Carriage return's have to return an empty string

str=input("(Hit Enter):","string");

// after hit enter, "str" must be an empty string
assert_checkequal(str, "");
