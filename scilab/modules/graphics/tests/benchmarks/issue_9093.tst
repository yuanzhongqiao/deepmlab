// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// benchmark created from non-regression test issue 9093

// addcolor become very slow on large color map

// <-- BENCH NB RUN : 10 -->
c = grand(300000, 3, "uin", 0, 7) * 36 / 255;
scf();

// <-- BENCH START -->
addcolor(c);
// <-- BENCH END -->