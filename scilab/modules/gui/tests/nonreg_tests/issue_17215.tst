// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 17215 -->
//
// <-- Bugzilla URL -->
// https://gitlab.com/scilab/scilab/-/issues/17215
//
// <-- Short Description -->
// findobj(searchHandles, ...) doesn't work if searchHandles is a row vector

h0 = scf(0);
h1 = scf(1);
a = findobj([h0 h1],"type","Axes");
assert_checkequal(size(a,"*"),2)
