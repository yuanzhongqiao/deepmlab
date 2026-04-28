// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 8258 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8258
//
// <-- Short Description -->
// fscanfMat did not read matrix file not formatted by fprintfMat.
//

ierr = execstr("r = fscanfMat(""SCI/modules/fileio/tests/nonreg_tests/bug_8258.txt"");", "errcatch");
if ierr <> 0 then pause, end
ref = [1;2;3];
if size(r, "c") <> size(ref, "c") then pause, end
if size(r, "r") <> size(ref, "r") then pause, end
if or(r <> ref) then pause,end
