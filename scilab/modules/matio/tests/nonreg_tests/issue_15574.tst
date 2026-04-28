// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//
// <-- Non-regression test for issue 15574 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15574
//
// <-- Short Description -->
// loadmatfile loads as uint8 logical hypermatrix and logical arrays in cells, instead of as booleans.

// Data files:
// - issue_15574_logical.mat created from Octave 4.4.0 with:
//      ba = true
//      bv = rand(1,4)<0.5
//      bm = rand(2,3)<0.5
//      bh = rand(3,4,2)<0.5
//      save -binary -7 issue_15574_logical.mat ba bv bm bh
// - issue_15574_cell_logical.mat created from Octave 4.4.0 with:
//      bs = true
//      bv = [0  1  1]==1
//      bm = [ 1  1  0
//             1  0  1
//           ]==1
//      bh = cat(3,[1 0 1],[1 0 0])==1
//      Cell_b = {bs bv ; bm bh}
//      save -binary -7 issue_15574_cell_logical.mat Cell_b

loadmatfile(fullfile(SCI, "modules", "matio", "tests", "nonreg_tests", "issue_15574_logical.mat"));
assert_checktrue(typeof(bh)=="boolean");
assert_checkequal(ba, %t);
assert_checkequal(bv, [%t, %f, %f, %t]);
assert_checkequal(bm, [%f, %t, %f;%f, %f, %f]);
assert_checkequal(bh(:,:,1), [%t, %t, %f, %t;%t, %f, %t, %t;%f, %f, %f, %t]);
assert_checkequal(bh(:,:,2), [%t, %t, %t, %t;%f, %f, %f, %f;%t, %f, %t, %t]);

clear
loadmatfile(fullfile(SCI, "modules", "matio", "tests", "nonreg_tests", "issue_15574_cell_logical.mat"));
assert_checkequal(Cell_b{1,1}, %t);
assert_checkequal(Cell_b{1,2}, [%f, %t, %t]);
assert_checkequal(Cell_b{2,1}, [%t, %t, %f;%t, %f, %t]);
assert_checkequal(Cell_b{2,2}, matrix([%t, %f, %t, %t, %f, %f], [1,3,2]));