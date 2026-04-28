// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Paul Bignier
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

//
// Norm 2 performance check,
// See https://gitlab.com/scilab/scilab/-/issues/5017
//

// <-- BENCH NB RUN : 1000 -->
n = 100000;
x = ones(n, 1);
x(n+1) = 1.e9;

// <-- BENCH START -->
norm(x);
// <-- BENCH END -->

// the reference states less than 4s