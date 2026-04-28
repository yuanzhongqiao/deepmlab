// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//
// <-- Non-regression test for issue 15570 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15570
//
// <-- Short Description -->
// loadmatfile() failed on utf-8 multibyte string

t = "ûòïéa";
ref = t;
savematfile("TMPDIR/text.mat","-v7.3","t") 
clear t;
loadmatfile("TMPDIR/text.mat");
assert_checkequal(t, ref);