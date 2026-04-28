// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 9123 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9123
//
// <-- Short Description -->
// strsubst does not handle group remplacement.
// -------------------------------------------------------------

assert_checkequal(strsubst("32", "/\d(.*)/", "$1", 'r'), "2")

