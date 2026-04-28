// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 201 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/201
//
// <-- Short Description -->
//     modulo function error


x=poly(0,'x');
q=200001;
if modulo(q*x,q)<>0 then pause,end
