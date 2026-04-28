// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17482 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17482
//
// <-- Short Description -->
// legend processing is broken if not all curves are given a string

clf
h1=plot([1 2 3;4 5 6;7 8 9]')
h2=legend("first","second");
assert_checkequal(h1(1),h2.links(1))
assert_checkequal(h1(2),h2.links(2))
