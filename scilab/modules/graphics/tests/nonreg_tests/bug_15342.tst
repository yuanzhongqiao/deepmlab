// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 15342 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15342
//
// <-- Short Description -->
// replot() and hence "Reframe to contents" action did not take into account
// the sizes of Text blocks.

scf();
plot(1)
xarc(0.8,1.2,0.4,0.4,0,360*64)
replot([0 0 2 2])
for a = 0:45:359
    s = msprintf("angle %d°\n",a);
    x = 1+0.2*cosd(-a+30);
    y = 1+0.2*sind(-a+30);
    xstring(x,y,s,a);
end
gca().children(1:8).box = "on";
gca().children(1:8).foreground = color("grey70");
isoview
// => Watch at this reference result
replot()
replot()
replot()
// => See the result. It should look like the bottom left plot of
// https://gitlab.com/scilab/scilab/uploads/3761f05a377ae06316ee8832033a5c3c/replot_with_xstrings.png
// Several replot() or "Reframe to contents" actions may be needed to converge
// to this optimal reframing. This is because Text objects are not zoomable.
// Their data sizes depend on data bounds.
