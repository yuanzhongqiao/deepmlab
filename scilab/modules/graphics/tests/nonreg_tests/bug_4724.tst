// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - Digiteo - Yann Collette
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 4724 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4724
//
// <-- Short Description -->
// When the variation of f of a data set is too small, plot hangs
// 

t=0:.01:%pi;
y=1+1e-9*cos(t);
plot(t,y)

// should not hang

