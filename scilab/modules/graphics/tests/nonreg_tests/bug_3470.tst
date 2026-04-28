// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009-2009 - Digiteo - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 3470-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3470
//
// <-- Short Description -->
// plot2d(), followed by legends produce an unexpected error.
// 

plot2d();
legends(string([1:3]),[-1 -2 3],1);

// plot2d used to corrupt the stack and legends was producing an error
