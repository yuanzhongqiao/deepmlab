// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 7424 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7424
//
// <-- Short Description -->
// Integer codec can produce a NuulPointerException

importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_7424.zcos");
// suceed if no exception (checked on stderr).

