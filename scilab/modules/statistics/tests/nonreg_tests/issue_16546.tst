// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16546 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16546
//
// <-- Short Description -->
// T-distribution is symmetric but the result computed by cdft was not.

p = 0.05/2;
q = 1-p;
for df = 1:10
    t = cdft('T', df, p, q);
    t2 = cdft('T', df, q, p);
    assert_checkalmostequal(t, -t2);
end