// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16575 -->
//
// <-- CLI SHELL MODE -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16575
//
// <-- Short Description -->
// for m=rand(2,2,2), end crashes Scilab

a(:, :, 1) = [1 2;3 4];
a(:, :, 2) = [5 6;7 8];
for m=a
    disp(m);
end