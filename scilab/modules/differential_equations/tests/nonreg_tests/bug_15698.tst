// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15698 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15698
//
// <-- Short Description -->
// intg roundoff error with a trivial integra

deff('y=f(t)','y=sin(t)');
assert_checkalmostequal(intg(0,2*%pi,f),0,[],2*%eps)