// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Pierre-Aime Agnel
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 13359 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13359
//
// <-- Short Description -->
// Nyquist datatip were not displaying negative frequencies properly
//
// <-- TEST WITH GRAPHIC -->

s = poly(0, 's');
h = syslin('c', 1 / (s + 1));
nyquist(h);

ax = gca();
pl = ax.children(1).children(2);
d1 = datatipCreate(pl, 200);
assert_checkequal(strindex(d1.text(2), "-"), 1);