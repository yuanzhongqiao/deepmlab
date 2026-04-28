// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->
// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 16772 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/16772
//
// <-- Short Description -->
//

// WARNING: there are two different tests below !

//
// TEST 1: Datatip fails when curve is on overlaping axes
//

clf
a1=newaxes();
a1.axes_bounds=[0,0,1.0,0.5];
t=0:0.1:20;
plot(t,acosh(t),'r')
a2=newaxes();
a2.axes_bounds=[0,0.5,1.0,0.5];
x=0:0.1:4;
plot(x,sinh(x))
// Now, the "Datatip" button in the toolbar can be tested: it works

// Here a2 is changed to partially overlap a1
a2.axes_bounds=[0,0.25,1.0,0.5];
a2.filled="off";

// Now, the "Datatip" button in the toolbar can be tested: click and create a datatip
// - on the top (non-overlapped) part of the red curve
// - on the middle (overlapped) part of the red curve (was not working before the fix)
// - on the middle (overlapped) part of the blue curve
// - on the bottom (non-overlapped) part of the blue curve

//
// TEST 2: Datatip fails when curve is child of a Frame uicontrol
//

clf
f = figure("layout", "gridbag", "backgroundcolor", [1 1 1]);
// Create the frames where each graph is put
c = createConstraints("gridbag", [1 1 1 1], [1 1], "both");
top_left = uicontrol(f, "style", "frame","constraints", c);

c.grid = [2 1 1 1];
top_right = uicontrol(f, "style", "frame", "constraints", c);

c.grid = [1 2 2 2];
bottom = uicontrol(f, "style", "frame", "constraints", c);

// Create the axes in each frame
a_tl = newaxes(top_left);
a_tr = newaxes(top_right);
a_bt = newaxes(bottom);

// Plot in the frames
X = (1:100) ./ 50;
plot(a_tl, X, X, "r");
plot(a_tr, X, cos(2 * %pi * 3 * X), "g");
plot(a_bt, X, exp(X), "b");

// Now, click the  "Datatip" button in the toolbar and try to create a datatip
// on any of the curve.