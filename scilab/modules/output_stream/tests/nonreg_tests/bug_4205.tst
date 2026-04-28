// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4205 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4205
//
// <-- Short Description -->
// When warning messages are disabled, a blank line is printed out

warning('off');
function y = mysubmacro ( x , factor )
  y = factor * x;
endfunction

warning("off");
mysubmacro( 1 , 1 );mysubmacro( 1 , 1 );mysubmacro( 1 , 1 );mysubmacro( 1 , 1);
warning('on');