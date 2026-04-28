// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
// <-- WINDOWS ONLY -->
//
// <-- Non-regression test for bug 17495 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17495
//
// <-- Short Description -->
// getVsWhereInformation.sci fails when vswhere returns []
//

lib("SCI/modules/dynamic_link/macros/windows/");

[_, _, txt] = string(getVsWhereInformation);

modified = strsubst(txt, "-requires Microsoft.Component.MSBuild", "-requires Microsoft.Component.MSBuil"); // Modify command to be sure it will return "[]" (the buggy case)

assert_checkfalse(and(txt==modified)); // Check that function contents has been modified by strsubst (could not be the case if the contents of getVsWhereInformation.sci changes)

assert_checktrue(execstr(modified, "errcatch")==0);
