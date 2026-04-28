// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17223 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17223
//
// <-- Short Description -->
// datenum() and datetime("now") now handle the milliseconds.

for i = 1:1000
    d = datevec(datenum());
    s = d(6);
    assert_checktrue((s - floor(s)) >= 0);
end

for i = 1:1000
    d = datetime();
    t = d.time;
    assert_checktrue(modulo(t, 1) >= 0);
end