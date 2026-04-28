// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16786 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16786
//
// <-- Short Description -->
// zoom_box property was not correctly saved.

file_name = fullfile(TMPDIR, "bug_16786.sod");

plot2d();
gca().zoom_box = [1.5 -1.5 5 1 -1 1];
f = gcf();
save(file_name, "f");
close();
load(file_name);
assert_checkequal(gca().zoom_box, [1.5, -1.5, 5, 1, -1, 1]);

