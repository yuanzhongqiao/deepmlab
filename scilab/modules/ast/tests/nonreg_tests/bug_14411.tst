// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 14411 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14411
//
// <-- Short Description -->
// abort crashes scilab in a loop while

// execute in scilab
while 1
    a=1
end

// then ctrl-C to break the loop
// scilab must not crashes after axecution of "abort"
