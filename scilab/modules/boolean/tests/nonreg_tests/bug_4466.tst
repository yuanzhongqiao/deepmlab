// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4466 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4466
//
// <-- Short Description -->
//   The .' operator is undefined for character string and boolean data types.

M=[%t,%f];
if or(M.'<>[%t;%f]) then pause,end

