// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 7367 -->
// <-- TEST WITH GRPAHIC -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7367
//
// <-- Short Description -->
// uimenu properties display was not consistent.

// Create a menu and display its properties value
// Do not remove display since it is used to compare with .dia.ref file
mymenu = uimenu(gcf(),"Label","Test") // Do not had a semi-colon here

delete(gcf());