//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - INRIA - Michael Baudin
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 7377 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7377
//
// <-- Short Description -->
//    thrownan failed on empty matrix

//
[nonan,numb]=thrownan([]);
assert_checkequal ( nonan , [] );
assert_checkequal ( numb , [] );

