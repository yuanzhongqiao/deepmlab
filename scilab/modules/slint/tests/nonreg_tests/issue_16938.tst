// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16938 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16938
//
// <-- Short Description -->
// Please make slint() applicable to scripts.sce, .start, and tests.tst files

scilabCode = "function issue_16938();a=1;endfunction"

fileExt = ["sce", "start", "quit", "tst" "txt" "code" "xyz"]
for ext = fileExt
    scilabFile = fullfile(TMPDIR, "issue_16938." + ext);
    mputl(scilabCode, scilabFile);
    assert_checkfalse(isempty(slint(scilabFile, "SCIHOME/slint.xml", %F).info));
end