// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for issue 17488-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17488
//
// <-- Short Description -->
// interrupted string freezes Scilab
// 

script = fullfile(TMPDIR,"test.sce");
mputl(["a=[""ddd"; """]"], script);
refError = ["a=[""ddd";
            "       ^^";
            "Error: 1.8->2.1 Unexpected end of line in a string."];
assert_checkerror ("exec(script)", refError);
