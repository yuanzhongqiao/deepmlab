// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17275 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17275
//
// <-- Short Description -->
// legend: Scilab crashes when an empty value is used as first input argument and 5 as the second one

plot(1:10);
for i=[-6:-1 1:5]
    assert_checkerror(msprintf("legend([],%d)",i), msprintf(_("%s: Wrong type for input argument #%d: handle or string expected\n"), "legend", 1));
end
