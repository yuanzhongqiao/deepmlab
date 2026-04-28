// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
// This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 16555 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16555
//
// <-- Short Description -->
// Details of Xcos CLOCK_c block led to Scilab crash
//

loadXcosLibs();
// "Details" call tree_show() which call list2tree()
// to flatten the structure
list2tree(CLOCK_c("define"));
