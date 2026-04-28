// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 8640 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8640
//
// <-- Short Description -->
//    The histplot function has failed when the data vector contains the same values
// =============================================================================
clf();
histplot(2, [2 2 2 2 2]);
a = gca();
x = a.children(1).children.data;
y = [%eps; 2; 2; 0; 0; 0; %eps];
// max(y)* 65536 * %eps because of l.122 of hisplot.sci
assert_checkalmostequal(y, x(:,2), [], max(y)* 65536 * %eps);


