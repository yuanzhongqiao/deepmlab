// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
// <-- Non-regression test for bug 14711 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14711
//
// <-- Short Description -->
// When targetting an uicontrol frame, colorbar() dis not display anything

demo_gui();
// Go to the GUI => UIcontrol 2 item. Then enter in the console:
colorbar(-1,1);
// The colorbar must be displayed on the right side of the frame
