//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - INRIA - Serge Steer 
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4249 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4249
//
// <-- Short Description -->
// The filter function does not work when the transfer function is a perfect pass all hz = 1/1.
Num=1;Den=1+%z;u=[1,2,3,4,5];
if or(filter(1,1,u)<>u) then pause,end

