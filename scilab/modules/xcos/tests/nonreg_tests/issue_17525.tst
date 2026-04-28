// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- XCOS TEST -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 17525 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17525
//
// <-- Short Description -->
// Trivial mistake on Text_f component help page using xcos

// 1 - Open a new Xcos Diagram
// 2 - Add a Text_t block and check that "Text_f" is displayed in it
// 3 - Add a CONST_m block
// 4 - Right-click on the "CONST_m" block, select "Block Help" and check that "CONST_m" documentation is displayed
// 5 - Right-click on the "Text_f" block, select "Block Help" and check that "Text_m" documentation is displayed
