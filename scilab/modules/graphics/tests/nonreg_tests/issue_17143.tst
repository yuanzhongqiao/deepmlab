// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antonie ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17143 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17143
//
// <-- Short Description -->
// declare head/tail before insertion incommt3d to avoird error about redefinition of function

t = linspace(-%pi,%pi,500)';
function z = traj(x, y)
    z = 1.5 * sin(x^2) * cos(y);
endfunction

comet3d(cos(t), sin(t), traj);