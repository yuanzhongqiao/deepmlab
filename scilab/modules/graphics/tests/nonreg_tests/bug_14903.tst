// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 14903 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14903
//
// <-- Short Description -->
// plot2d crashed if the figure has no axes.

f = scf();
f.default_axes = "off";
delete(f.children(1))
plot2d()