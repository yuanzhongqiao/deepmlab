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
// <-- Non-regression test for issue 17233 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17233
//
// <-- Short Description -->
// bar fails with # format colors (#aabbcc)

f1 = scf(); bar(1, ones(1, 8), 0.8, ["black" "red" "green" "blue" "yellow" "magenta" "cyan" "white"]);
f2 = scf(); bar(1, ones(1, 8), 0.8, ["#000000" "#ff0000" "#00ff00" "#0000ff" "#ffff00" "#ff00ff" "#00ffff" "#ffffff"]);
assert_checkequal(f1.children.children.children.background, f2.children.children.children.background);

close(winsid());

f1 = scf(); bar(1, ones(1, 8), 0.8, ["black" "red" "green" "blue" "yellow" "magenta" "cyan" "white"]);
f2 = scf(); bar(1, ones(1, 8), 0.8, ["#000000" "#FF0000" "#00FF00" "#0000FF" "#FFFF00" "#FF00FF" "#00FFFF" "#FFFFFF"]);
assert_checkequal(f1.children.children.children.background, f2.children.children.children.background);
