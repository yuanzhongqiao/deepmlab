// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Bruno JOFRET
// Copyright (C) 2021 - 2023 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// =======================
// subplot() unitary tests
// =======================

// Check each current figure property
clf reset
f = gcf()
a1 = gca();

// Assert axes fill all figure
assert_checkequal(a1.axes_bounds, [0 0 1 1]);
// Assert figure only has 1 child
assert_checkequal(size(f.children), [1 1]);
assert_checkequal(f.children(1).type, "Axes");

subplot(10,10,1);
a2 = gca();
// Assert figure has still one child
assert_checkequal(size(f.children), [1 1]);
assert_checkequal(a2.axes_bounds, [0 0 0.1 0.1]);
// a2 == a1: simply check on axes bounds
assert_checkequal(a1.axes_bounds, [0 0 0.1 0.1]);

subplot(10,10,100);
a3 = gca();
// Assert figure has two children now
assert_checkequal(size(f.children), [2 1]);
assert_checkequal(a1.axes_bounds, [0 0 0.1 0.1]);
assert_checkequal(a3.axes_bounds, [0.9 0.9 0.1 0.1]);

subplot(10,10,10);
a4 = gca();
// Assert figure has three children now
assert_checkequal(size(f.children), [3 1]);
assert_checkequal(a1.axes_bounds, [0 0 0.1 0.1]);
assert_checkequal(a3.axes_bounds, [0.9 0.9 0.1 0.1]);
assert_checkequal(a4.axes_bounds, [0.9 0 0.1 0.1]);

subplot(10,10,91);
a5 = gca();
// Assert figure has four children now
assert_checkequal(size(f.children), [4 1]);
assert_checkequal(a1.axes_bounds, [0 0 0.1 0.1]);
assert_checkequal(a3.axes_bounds, [0.9 0.9 0.1 0.1]);
assert_checkequal(a4.axes_bounds, [0.9 0 0.1 0.1]);
assert_checkequal(a5.axes_bounds, [0 0.9 0.1 0.1]);

// subplot can't use the default axes if it's not clean:
// https://www.mail-archive.com/users@lists.scilab.org/msg10455.html
clf reset
f = gcf();
title("The  overall  title", "fontsize", 4);
subplot(1,2,1)
plot(1:10)
assert_checkequal(length(f.children), 2);
assert_checkequal(f.children(2).title.text, "The  overall  title");

// subplot output
clf reset
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
assert_checkequal(ax2,gca());
subplot(1,2,1);
assert_checkequal(ax1,gca());


// ---------
// on frames
// ---------
f = figure("default_axes","off", "toolbar","none", "name","subplot in frames", ..
           "backgroundColor",[1 1 1]*0.97);
x = -4:0.05:4;

// Frame #1
b = createBorder("titled", "Frame #1");
fr1 = uicontrol(f, "style", "frame", "units","normalized", "border", b, ..
                   "position", [0.03 0.83 0.94 0.15]);
assert_checkequal(f.children.type, "uicontrol");

// Frame #2
b(2) = "Frame #2";
fr2 = uicontrol(f, "style", "frame", "units","normalized", "border", b, ..
                   "position", [0.03 0.03 0.60 0.8]);
assert_checkequal(f.children.type, ["uicontrol" "uicontrol"]');

a2 = newaxes(fr2);
subplot(1,2,1);
e = gce();
assert_checkequal(e.type, "Axes");
assert_checkequal(e.parent.type, "uicontrol");
assert_checkequal(e.axes_bounds, [0,0,0.5,1]);
plot(x, tanh(x)), title("tanh")

subplot(2,2,2)
e = gce();
assert_checkequal(e.type, "Axes");
assert_checkequal(e.parent.type, "uicontrol");
assert_checkequal(e.axes_bounds, [0.5,0,0.5,0.5]);
plot(x, sinh(x)), title("sinh")


// Frame #3
b(2) = "Frame #3";
fr3 = uicontrol(f, "style", "frame", "units","normalized", "border", b, ..
                   "position", [0.65 0.03 0.32 0.8]);
assert_checkequal(f.children.type, ["uicontrol" "uicontrol" "uicontrol"]');

newaxes(fr3);
subplot(2,1,1)
e = gce();
assert_checkequal(e.type, "Axes");
assert_checkequal(e.parent.type, "uicontrol");
assert_checkequal(e.axes_bounds, [0,0,1,0.5]);
plot(2*x, sinc(2*x)), title("sinc")

subplot(2,1,2)
e = gce();
assert_checkequal(e.type, "Axes");
assert_checkequal(e.parent.type, "uicontrol");
assert_checkequal(e.axes_bounds, [0,0.5,1,0.5]);
plot(2*x, sin(2*x)), title("sin")

// Back to Frame #2
sca(a2);
subplot(2,2,4)
e = gce();
assert_checkequal(e.type, "Axes");
assert_checkequal(e.parent.type, "uicontrol");
assert_checkequal(e.axes_bounds, [0.5,0.5,0.5,0.5]);
plot(x, cosh(x)), title("cosh")


assert_checkequal(f.children(1).children.type, ["Axes" "Axes"]');
assert_checkequal(f.children(1).children.title.text, ["sin" "sinc"]');
assert_checkequal(f.children(2).children.type, ["Axes" "Axes" "Axes"]');
assert_checkequal(f.children(2).children.title.text, ["cosh" "sinh" "tanh"]');
assert_checkequal(f.children(3).children, []);

