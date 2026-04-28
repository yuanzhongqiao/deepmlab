// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17259-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17259
//
// <-- Short Description -->
// Valgrind reports a memleak on `string([1 2])`

// use struct() to for the outline print where was located the memory leak
disp(struct());
