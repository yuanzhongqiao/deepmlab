// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15566 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15566
//
// <-- Short Description -->
// matrix insertion checked overall size but not individual dimensions

scalar = 5;
vect = 1:5;
vect2 = 6:10;
mat = [1,2,3,4;5,6,7,8];
hm = zeros(3,4,2); hm(:) = 1:24;

assert_checkerror("a=mat; a(:,:,2) = 9:16", "Submatrix incorrectly defined.");
assert_checkerror("a=mat; a(:,:,:,2) = 9:16", "Submatrix incorrectly defined.");
assert_checkerror("a=hm; a(:,:) = hm(:)", "Submatrix incorrectly defined.");
assert_checkerror("a=hm; a(:,:,:,2) = hm(:)", "Submatrix incorrectly defined.");
assert_checkerror("a=mat; a(:,:) = mat(:)", "Submatrix incorrectly defined.");
assert_checkerror("a=mat; a(:,:,2) = mat(:)", "Submatrix incorrectly defined.");
assert_checkerror("a=mat; a(:,:,:,2) = mat(:)", "Submatrix incorrectly defined.");
