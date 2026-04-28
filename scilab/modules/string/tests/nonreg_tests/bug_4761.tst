// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4761 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4761
//
// Short description:
// memory leak in grep with regexp crashes scilab

a = string(rand(500,10));
for i = 1:500 
  b = grep(a,'/123|456$/','r');
end 
