// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16845 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16845
//
// <-- Short Description -->
// Replot button or replot(gcf()) instruction failed for legends

t=[0:0.1:2*%pi]';
scf() ;
gca().line_style = 2;
plot2d(t,cos(t),style=5);
gca().line_style = 4;
plot2d(t,sin(t),style=3);
legends(["sin(t)";"cos(t)"],[[5;2],[3;4]], with_box=%f, opt="ll")

databounds = gcf().children(1).data_bounds;
replot(gcf())
assert_checkequal(gcf().children(1).data_bounds, databounds);