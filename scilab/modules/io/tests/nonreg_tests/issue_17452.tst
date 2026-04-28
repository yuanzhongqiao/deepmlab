// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17452 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17452
//
// <-- Short Description -->
// genlib makes Scilab crash when macro code contains extra parenthesis

temp = fullfile(TMPDIR, "genlibissue")
mkdir(temp)
mputl([
"function genlibissue()";
"    msprintf(""%s"", ""bug""))";
"endfunction"], fullfile(temp, "genlibissue.sci"))
ierr = execstr("genlib(""issuelibrary"", temp)", "errcatch");
assert_checktrue(ierr <> 0); //error is normal but not crashes
