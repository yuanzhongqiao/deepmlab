// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14685 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14685
//
// <-- Short Description -->
//    datavec produced an invalid index error.
// =============================================================================

horodeb= datenum(2016,12,31,23,0,0);
horofin= datenum(2016,12,31,23,59,59);
horoj= [horodeb:1/1440:horofin]' ;
horoj_clair= zeros(size(horoj,1),6);
horoj_clair= datevec(horoj);
assert_checkalmostequal(datenum(horoj_clair), horoj);
