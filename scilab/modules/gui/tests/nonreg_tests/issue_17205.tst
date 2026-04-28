// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->
// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 17205 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17205
//
// <-- Short Description -->
// Error was not well managed in main_menubar_cb 
// when no informations were found in favoriteDirectories and openFiles
// sections of scinotesConfiguration.xml that cause Scilab exit with 
// a non-zero status.

// Launch Scilab in GUI mode without favorite directory or file opened in scinotes.
// The execution of lasterror() must return no error.
