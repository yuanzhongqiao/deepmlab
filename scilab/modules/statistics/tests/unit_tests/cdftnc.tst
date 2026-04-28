// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// =============================================================================
// Tests for cdftnc() function
// =============================================================================

t = 1:10;
df = 2 * ones(t);
pn = zeros(t);

[p, q] = cdftnc("PQ", t, df, pn);
t1 = cdftnc("T", df, pn, p, q);
df1 = cdftnc("Df", pn, p, q, t);
pn1 = cdftnc("Pnonc", p, q, t, df);

assert_checkalmostequal(t1, t);
assert_checkalmostequal(df1, df);
assert_checkalmostequal(pn1, pn, [], 1e-10);

[p, q] = cdftnc("PQ", -t, df, pn);
t1 = cdftnc("T", df, pn, p, q);
df1 = cdftnc("Df", pn, p, q, -t);
pn1 = cdftnc("Pnonc", p, q, -t, df);

assert_checkalmostequal(t1, -t);
assert_checkalmostequal(df1, df);
assert_checkalmostequal(pn1, pn, [], 1e-10);

t = [0.158,0.816,1.250,1.533,2.015,2.447,2.998];
df = [1,2,3,4,5,6,7];
pn = df./10;

[p, q] = cdftnc("PQ", t, df, pn);
t1 = cdftnc("T", df, pn, p, q);
df1 = cdftnc("Df", pn, p, q, t);
pn1 = cdftnc("Pnonc", p, q, t, df);

assert_checkalmostequal(t1, t);
assert_checkalmostequal(df1, df);
assert_checkalmostequal(pn1, pn);



df      = 1;
pn      = 0;

f        = %inf; // Inf
[P,Q]    = cdftnc("PQ", f, df, pn);
assert_checkequal(P, 1);
assert_checkequal(Q, 0);

f        = %nan; // NaN
[P,Q]    = cdftnc("PQ", f, df, pn);
assert_checkequal(P, %nan);
assert_checkequal(Q, %nan);
