// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- INTERACTIVE TEST -->

//
// <-- Non-regression test for bug 11363 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11363
//
// <-- Short Description -->
// figure.visible = "on" de-iconify window

f = gcf();

//minimize new figure

f.visible = "on";

//figure must raise from taskbar