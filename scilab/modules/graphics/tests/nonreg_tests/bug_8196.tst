// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 8196 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8196
//
// <-- Short Description -->
// Some error message are still not standard.

plot(1:10);
e=gce();
refMsg = msprintf(_("Wrong value for ''%s'' property: Must be greater or equal to %d.\n"), "thickness", 0);
assert_checkerror("e;e.thickness = -1;", refMsg);
refMsg = msprintf(_("Wrong value for ''%s'' property: Integer between %d and %d expected.\n"), "line_style", 1, 10);
assert_checkerror("e;e.line_style = -1;", refMsg);
refMsg = msprintf(_("Wrong value for ''%s'' property: Must be greater or equal to %d.\n"), "mark_size", 0);
assert_checkerror("e;e.mark_size = -1;", refMsg);
