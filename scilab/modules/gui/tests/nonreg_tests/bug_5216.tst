// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 5216 -->
// <-- INTERACTIVE TEST -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5216
//
// <-- Short Description -->
// In ATOMS GUI, it would be nice to be able to click on link or at least to copy/paste the URL.


h = uicontrol("style","text",..
	"string", "<a href=""https://www.scilab.org/"">Visit Scilab website...</a>",..
	"position",[20 20 200 200], ...
	"fontsize", 15)

// Click on the link and check that a web browser is opened