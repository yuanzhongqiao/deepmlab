// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
//
// <-- Non-regression test for bug 302 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/302
//
// <-- Short Description -->
//    You can't have space inside the string put in 'callback' unless you put a pair of curly brackets ('{}') around them.

h=figure();
hb=uicontrol(h, "style", "pushbutton", ...
    "position", [25,25,40,20], ...
    "callback","disp(""Hello worlds"")", ...
    "string", "Test");
