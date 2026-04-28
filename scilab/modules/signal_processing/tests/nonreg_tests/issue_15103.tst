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
// <-- Non-regression test for issue 15103 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15103
//
// <-- Short Description -->
// xcorr leads to immediate crash
//

a=1:2000;
b=a;
xcorr(a,b);
