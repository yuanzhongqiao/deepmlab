// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15741 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15741
//
// <-- Short Description -->
// Operations between 2 polynomials with distinct variables no longer call the corresponding overloads (Regression)

assert_checkerror("%s+%z",["Undefined operation for the given operands.";"check or define function %p_a_p for overloading."])
assert_checkerror("%s-%z",["Undefined operation for the given operands.";"check or define function %p_s_p for overloading."])
assert_checkerror("%s*%z",["Undefined operation for the given operands.";"check or define function %p_m_p for overloading."])
