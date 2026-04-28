// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NOT FIXED -->  6.0.0 -> 6.0.2
//
// <-- Non-regression test for bug 3222 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3222
//
// <-- Short Description -->
// indexing problem
clear D;D(1)(2)="3";
if or(D<>["" "3"]) then pause,end

clear D;D(1).x="3";
if D.x<>"3" then pause,end

clear D;D(1,2).x="3";
if D(1).x<>[]  then pause,end
if D(2).x<>"3"  then pause,end


clear D;D.x(1,2)="3";
if or(D.x<>["" "3"]) then pause,end

clear D;D(1,1,2)="3";
if D(1,1,2)<>"3"  then pause,end
