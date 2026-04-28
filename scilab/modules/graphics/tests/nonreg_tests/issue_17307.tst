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
// <-- Non-regression test for issue 17307 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17307
//
// <-- Short Description -->
// Dead datatip is found by get() after figure delete

t = linspace(0,2*%pi,128);
h = plot(t,[sin(t);cos(t);sin(2*t)])(3);

hd = datatipCreate(h,[3*%pi/4 sqrt(2)/2]);
hd.tag = "datatip";

delete(gcf());

assert_checkfalse(is_handle_valid(hd));
assert_checkequal(get("datatip"), []);

