//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4275 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4275
//
// <-- Short Description -->
//   g_margin function does not work properly

s=poly(0,'s');
L = syslin('c',1,s*(1+s)^2);  
[g,f]=g_margin(L);
if abs(f*2*%pi-1)>100*%eps then pause,end
if abs(g-20*log10(2))>100*%eps then pause,end
