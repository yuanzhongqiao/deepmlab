// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 9350 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9350
//
// <-- Short Description -->
// abs(complex(%nan,0)) returns zero instead of nan


function flag = assert_true ( computed )
  if ( computed ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

y = abs(complex(%nan,0));
assert_true ( isnan(y) );

