// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17412 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17412
//
// <-- Short Description -->
// when h was an Axes handle legend(h, ...) used gca() instead 

clf();
subplot(1,2,1);
h1 = gca();
plot(1:10,sin(1:10),'r');
subplot(1,2,2);
h2 = gca();
plot(1:10,sin(1:10));
leg1 = legend(h1,"red sine");
found_leg = findobj(h1,"type","Legend");
assert_checkequal(found_leg,leg1);
