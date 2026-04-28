// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// <-- Non-regression test for bug 17147 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17147
//
// <-- Short Description -->
// regexp() and strsubst() have invalid memory access

computed = regexp("//","/\/|\\/");
assert_checkequal(computed, [1, 2]);

computed = strsubst("//","/\/|\\/", "", "regexp");
assert_checkequal(computed, "");