// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 1126 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1126
//
// <-- Short Description -->
// GIF driver  don't take into account the size of the window.

// create a figure
x = [0,1];
z = [0 0.5;0.5 1];

driver("GIF"); 
xinit(fullfile(TMPDIR,"bug_1126.gif"));

f = gcf();
f.figure_size = [800,600];
f.color_map = [jet(64);[0.9 0.9 0.9]];
f.background = 65;
   
colorbar(0,1,colminmax=[1,64]);
Sgrayplot(x,x,z,colminmax=[1,64]);

xtitle("new mode is used: 800 x 600 picture ?");

// export it to gif
xend();
driver("Rec");

// Then open bug_1126.gif in a image viewer. 


