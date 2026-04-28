// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17383 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17383
//
// <-- Short Description -->
// fromJSON("{inf:41}") causes crash

msgerr = msprintf(_("%s: %s\n"), "fromJSON", "Missing a name for object member at offset 1 near `inf:41}`");
assert_checkerror("fromJSON(""{inf:41}"")", msgerr);