// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 10449 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10449
//
// <-- Short Description -->
// On restoration, empty tabs could appear if the previous session was not
// cleanly exited.

// Open Scilab with the default desktop
// Undock and close all the tabs except the console
// type quit() in the console
// Reopen Scilab, all must be ok.