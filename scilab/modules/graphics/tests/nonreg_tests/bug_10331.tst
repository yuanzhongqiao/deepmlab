// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 10331 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10331
//
// <-- Short Description -->
// datatipCreate produces a warning and an error instead of a warning if the curve user_data is not a struct
plot(1:10);
e=gce();p=e.children;
p.user_data=3;
assert_checktrue(execstr("h=datatipCreate(p,5)","errcatch")==0);
assert_checkequal(type(h),9);
assert_checkequal(h.type, "Datatip");

