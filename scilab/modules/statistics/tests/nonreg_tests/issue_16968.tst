// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16968 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16968
//
// <-- Short Description -->
// cov generated a warning (xerbla) or maked Scilab crash (MKL generation issue).

x = [1; 2];
y = [3; 4];
C = cov(x, y)
expected = [0.5, 0.5; 0.5, 0.5];
C = cov([x, y]);
assert_checkequal(C, expected);

x = [230; 181; 165; 150; 97; 192; 181; 189; 172; 170];
y = [125; 99; 97; 115; 120; 100; 80; 90; 95; 125];
expected = [103721, -4001;-4001, 3664]./[90, 45;45, 15];
C = cov([x, y]);
assert_checkalmostequal(C, expected);