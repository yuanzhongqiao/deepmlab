// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 13360 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13360
//
// <-- Short Description -->
// hilbert function make scilab crash.
//

m=25;
n=2*m+1;
y=hilbert(eye(n,1));
