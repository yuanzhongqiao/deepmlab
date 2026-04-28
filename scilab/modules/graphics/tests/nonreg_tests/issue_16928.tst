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
// <-- Non-regression test for issue 16928 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16928
//
// <-- Short Description -->
// Manually created ticks are not saved

h=figure();
plot([0,1],[0,1]);
a = gca();

// set manual tick
a.x_ticks = tlist(["ticks", "locations", "labels", "interpreters"], 0.5, "xxx", "auto");
a.y_ticks = tlist(["ticks", "locations", "labels", "interpreters"], 0.5, "yyy", "auto");

// save figure
save(fullfile(TMPDIR, "issue_16928.bin"), "h")
close();

// load figure
load(fullfile(TMPDIR, "issue_16928.bin"));
a = gca();
assert_checkequal(a.x_ticks.locations, 0.5);
assert_checkequal(a.x_ticks.labels, "xxx");
assert_checkequal(a.x_ticks.interpreters, "auto");
assert_checkequal(a.y_ticks.locations, 0.5);
assert_checkequal(a.y_ticks.labels, "yyy");
assert_checkequal(a.y_ticks.interpreters, "auto");
