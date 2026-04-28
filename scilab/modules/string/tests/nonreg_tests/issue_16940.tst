// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16940 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16940
//
// <-- Short Description -->
// string of cell, struct, list does not call overload
// -------------------------------------------------------------

assert_checkequal(string({}), "{}");
assert_checkequal(string(list()), []);
assert_checkequal(string(struct()), []);
plot();
assert_checkequal(string({gce(),gce().children(1)}), ["[Compound]","[Polyline]"]);
