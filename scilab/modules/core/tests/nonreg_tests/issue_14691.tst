// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14691 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14691
//
// <-- Short Description -->
// scilab crashes when code is halted then aborted
//

Create a file with:
while %T
    sleep(2000);
end

1/ run test.sce (attachement)
2/ halt execution with Ctrl+C command
3/ type in "abort"
4/ scilab crashes
