// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17338 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17338
//
// <-- Short Description -->
// detectImportOptions detected double type instead of string.

txt = ["1.0,158,xxx";
        "2.0,3E9,yyy";
        "3.0,3C9,zzz";]
        
fileName = strsubst(tempname(), ".tmp", ".csv");

mputl(txt, fileName);
opts = detectImportOptions(fileName);
assert_checkequal(opts.variableTypes(2), "string");