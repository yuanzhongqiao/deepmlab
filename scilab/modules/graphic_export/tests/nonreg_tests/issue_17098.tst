// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17098 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17098
//
// <-- Short Description -->
// graphic export should be possible for Frames containing Axes

f = gcf();
plot(1:10,sin(1:10));
path_figure = TMPDIR + "/issue_17098_figure.png";
xs2png(f, path_figure);
clf;

// generate the same graph on an Axes within a Frame
fr=uicontrol(f,"style","frame","position",[0 0 1 1],"units","normalized");
a=newaxes(fr);
plot(a,1:10,sin(1:10));
path_frame = TMPDIR + "/issue_17098_frame.png";
xs2png(fr, path_frame);

// Check exported PNG images are the same
assert_checkequal(getmd5(path_figure),getmd5(path_frame));
