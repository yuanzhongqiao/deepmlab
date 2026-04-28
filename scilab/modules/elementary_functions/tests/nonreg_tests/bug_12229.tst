// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Simon MARCHETTO
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 12229 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12229
//
// <-- Short Description -->
// Slight numerical difference between sum(x(:,...),"c") and sum(x(1,...),"c") ?

t = linspace(0,1,30);
x = [cos(t); zeros(t)];

a = 100*sum(x(1,2:2:$),"c");
b = 0.0 + 100*sum(x(1,2:2:$),"c");

assert_checkequal(a - b, 0.0);
