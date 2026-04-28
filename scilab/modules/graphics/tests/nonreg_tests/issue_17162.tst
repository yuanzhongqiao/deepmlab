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
// <-- Non-regression test for issue 17162 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17162
//
// <-- Short Description -->
// call to subplot() changes current figure to last figure modified

// first figure
fh0 = scf();
subplot(2,1,1);
plot2d([1,2],[-2,2],1);
subplot(2,1,2);
plot2d([1,2],[-2,2],1);
fa = gcf();
assert_checkequal(fh0.figure_id, 0);
assert_checkequal(fh0.figure_id, fa.figure_id);

// second figure
fh1 = scf();
subplot(2,1,1);
plot2d([1,2],[2,-2],1);
subplot(2,1,2);
plot2d([1,2],[2,-2],1);
fa = gcf();
assert_checkequal(fh1.figure_id, 1);
assert_checkequal(fh1.figure_id, fa.figure_id);

// selecting the first one 
scf(fh0);
fa = gcf();
assert_checkequal(fh0.figure_id, fa.figure_id);
// call subplot
subplot(2,1,1);
plot2d([1,2],[-2,2],2);
fa = gcf();
assert_checkequal(fa.figure_id, 0);