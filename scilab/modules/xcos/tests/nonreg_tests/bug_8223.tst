// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Clément DAVID <clement.david@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->

// <-- Non-regression test for bug 8223 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8223
//
// <-- Short Description -->
// Loading an Xcos file after building the doc did not work

// loading the Saxon xml engine
execstr("buildDoc(1)", "errcatch");

// check that saxon is on the classpath
CP = javaclasspath();
if find(strstr(CP, "Saxon") <> "") == [] then pause, end

// launching xcos with a file must not produce an error
importXcosDiagram("SCI/modules/xcos/tests/nonreg_tests/bug_7015.zcos")
