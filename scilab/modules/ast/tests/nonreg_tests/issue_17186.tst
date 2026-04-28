// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17186 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17186
//
// <-- Short Description -->
// arguments helpers crashed when on non existing variables

a = ["function does_not_work(a)"
    "    arguments"
    "        a {mustBeA(b,""string"")}"
    "    end"
    "    mprintf(a);"
    "end"];

msg = _("%s: Identifier ''%s'' must be an input argument.\n");
assert_checkerror("execstr(a)", msg, [], "does_not_work", "b");



