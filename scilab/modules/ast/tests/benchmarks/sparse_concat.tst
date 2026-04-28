// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// Benchmark concatenation of sparse
a = sprand(10000, 10000, 0.01);
b = sprand(10000, 10000, 0.01);

// <-- BENCH NB RUN : 10 -->
// <-- BENCH START -->
[a b];
[a;b];
// <-- BENCH END -->
