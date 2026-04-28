// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15836 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15836
//
// <-- Short Description -->
// The product * with int64 and uint64 integers > 2^52 is not reliable

i = (int64(2)^62)+[1 56];
r = int64(ones(2,1)) * i;
assert_checktrue(and(r(1,:)==i));

i = (uint64(2)^62)+[1 56];
r = uint64(ones(2,1)) * i;
assert_checktrue(and(r(1,:)==i));
