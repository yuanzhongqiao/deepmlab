// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 12189 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12189
//
// <-- Short Description -->
// for expression segfault when overwrite increment

for i = 1 : 10
    i = 100;
end
