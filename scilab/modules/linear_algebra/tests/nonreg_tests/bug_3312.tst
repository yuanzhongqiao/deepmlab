//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2008 - INRIA - Michael Baudin
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3312 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3312
//
// <-- Short Description -->
// Wrong companion matrix when the polynomial is complex.

p=1+%i+2*%s;
computed=companion(p);
expected=[-(1+%i)/2];
if abs(expected-computed)>%eps then pause,end

