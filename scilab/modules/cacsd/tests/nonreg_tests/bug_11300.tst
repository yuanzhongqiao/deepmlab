// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
//
//
// <-- Non-regression test for bug 11300 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11300
//
// <-- Short Description -->
// freson calculates wrong frequencies

s = %s;
h = syslin('c', 0.5 * (2*s+1)/s^2 / (s^2 + 0.4*s + 4));
hc = (2*h) /. 1;

ref= [0.3098445669312;0.0720289283079]; 

assert_checkalmostequal(freson(hc), ref);
