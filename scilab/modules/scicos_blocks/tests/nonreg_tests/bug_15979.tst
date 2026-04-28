// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- XCOS TEST -->
// <-- INTERACTIVE TEST -->  Last check: 6.1.0-master 2019-02-24
//
// <-- Non-regression test for bug 15979 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15979
//
// <-- Short Description -->
//  * EXPRESSION block: for multi-character powers, only the first character was displayed in
//    exponent on the icon
//  * CLR and DLR blocks: same issue when the power is specified through a variable whose name
//    is more than 2-character long.

// TEST:

xcos("SCI/modules/scicos_blocks/tests/nonreg_tests/bug_15979.zcos");

// For each block:
//  * Double-click on the block to open its parameters interface.
//  * Press "OK" to validate the existing inputs.
//  * Check that the display of exponents on its icon is still correct.
//    Reference display: https://gitlab.com/scilab/scilab/uploads/0ddc5b8ef547865f6636e429b3a85542/bug_15979.png
//    All the multi-char exponents must be correctly displayed on the blocks icons
//     - literal numbers: "1.5", "2.3", "+10", "10"
//     - "ab" or "%eps" variable
//     - "(1.5-%eps)" expression
//  * By the way, special characters "%", "&" and "<" must be also well displayed.
