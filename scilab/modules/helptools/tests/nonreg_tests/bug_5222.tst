// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 5222 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5222
//
// <-- Short Description -->
// help command can generate a "critical exception".

for i = 1:100
    ierr = execstr("doc numderivative","errcatch");
    assert_checkequal(ierr, 0);
end
