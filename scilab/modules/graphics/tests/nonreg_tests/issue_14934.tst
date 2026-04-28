// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14934 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14934
//
// <-- Short Description -->
// Deleting a datatip with delete(dtHandle) creates a ghost "????" component in dtHandle.parent.datatips

x=linspace(1,10,100);
plot2d(x,sin(x));
c = gce(); c = c.children;
datatipCreate(c,[3 0]);
d = datatipCreate(c,[6 -0.3]);
datatipCreate(c,[7 0.5]);
delete(d);
assert_checkequal(size(c.datatips, "*"), 2);
assert_checkequal(c.datatips(2).type, "Datatip");

