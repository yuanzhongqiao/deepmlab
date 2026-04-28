// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17168 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17168
//
// <-- Short Description -->
// subplot is broken when demo panel is open

close(winsid());
f = createWindow();
f.layout = "border";
uicontrol(f, "style", "frame");
subplot(2, 2, 1);
assert_checkequal(length(winsid()), 2);
close(winsid());

