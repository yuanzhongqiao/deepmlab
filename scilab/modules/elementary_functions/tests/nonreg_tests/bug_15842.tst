// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15842 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15842
//
// <-- Short Description -->
// unique() yielded an error for 2D sparse matrices

s = int(sprand(10,20,0.05)*10);
assert_checkequal(unique(s), sparse(unique(full(s))));

r = unique(s, "keepOrder");
ref = sparse(unique(full(s), "keepOrder"));
assert_checkequal(r, ref);

r = unique(s, "uniqueNan");
ref = sparse(unique(full(s), "uniqueNan"));
assert_checkequal(r, ref);

r = unique(s, "keepOrder", "uniqueNan");
ref = sparse(unique(full(s), "keepOrder", "uniqueNan"));
assert_checkequal(r, ref);
