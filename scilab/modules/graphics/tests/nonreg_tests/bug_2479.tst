// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 2479 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2479
//
// <-- Short Description -->
// Graphic editor could not be used when format was not format("v",18).

if getos() <> "Darwin"
    format('e',10);
    plot();
    ged(8,0);
end
