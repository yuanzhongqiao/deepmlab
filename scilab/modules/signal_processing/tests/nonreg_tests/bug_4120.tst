//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4120 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4120
//
// <-- Short Description -->
//  IIR filter desing demo fails under Windows 64 (XP and Vista).

y = amell(1.1503675,0.5653572);
if y == 0 then pause,end

ref = 1.0883305;
if abs(y - ref)> 10e-8 then pause,end
