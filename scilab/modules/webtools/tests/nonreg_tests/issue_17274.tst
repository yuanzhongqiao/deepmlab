// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17274 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17274
//
// <-- Short Description -->
// toJSON creates "\/" string in place of "/"

txt = "{""burn_rate_units"":""m/s""}";
st = fromJSON(txt);
json = toJSON(st);
assert_checkequal(json, txt);

