// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan SIMON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 5164 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5164
//
// <-- Short Description -->
//    One can undo a diagram just after loading it


xcos(SCI+"/modules/xcos/demos/Threshold_ZeroCrossing.zcos");
// <CTRL+Z>
// check that nothing should have changed

