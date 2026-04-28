// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 7550 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7550
//
// <-- Short Description -->
// The keyword case was misplaced in particular conditions

// launch SciNotes
// just type:
// \t\t\tselect\n
//          case\n // when \n is entered 'case' go to the same level as 'select'
//                 // OK
// so you have:
// \t\t\tselect
// \t\t\tcase
// Enter a new CR just after 'case' and now it doesn't move
