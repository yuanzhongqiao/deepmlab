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
// <-- Non-regression test for issue 7475 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7475
//
// <-- Short Description -->
// When running fft, the scilab program crashes.
//

t = [0:0.1:2*%pi];
x = sin(t);
y = fft(x);
