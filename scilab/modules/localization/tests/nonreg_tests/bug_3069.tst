//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010-2010 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3069 -->
//
// <-- ENGLISH IMPOSED -->"
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3069
//
// <-- Short Description -->
//    bug 3069 fixed - In some cases, the function gettext was returning \"
//

str = gettext("%s: Wrong input argument #%d: ""%s"" or ""%s"" expected.\n");
if grep(str,"\""") then pause, end
