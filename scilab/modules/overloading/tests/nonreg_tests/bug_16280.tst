// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 16280 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15280
//
// <-- Short Description -->
// mode()=-1 in overloads prevents  choosing compact/not compact display mode

r = [1/%s %s/(1+%s)^2];
r = [r ; 1+r];

for i=-1:2
    mode(i)
    mprintf("mode: %d\n", mode())
    mprintf("-------------------\n")
    r
    mprintf("-------------------\n")
end