// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 3102 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3102
//
// <-- Short Description -->
// regexp returns a "Unknown error"


r="/^b.*b.*b.*b.*b$/";
b = "b";
for i = 1:123
  b = b + "b";
end;
b = b + "r";
ierr=execstr("regexp(b, r)","errcatch");
assert_checkequal(ierr, 0);