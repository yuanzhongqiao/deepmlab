// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16029 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16029
//
// <-- Short Description -->
// plot2d([1 2]*1e-14): Y-axis extending out of its range for small Y values

t=linspace(1e-200,1e-30,100);
scf(1)
plot(t,sin(t))
// x axis should be between 0 and 1e-30
// y axis should be between 0 and 1e-30

scf(2)
plot(t,sin(t))
gca().tight_limits="on"
// x axis should be between 0 and 1e-30
//   in this mode, 0 is not visible
// y axis should be between 0 and 1e-30
//   in this mode, 0 is not visible
