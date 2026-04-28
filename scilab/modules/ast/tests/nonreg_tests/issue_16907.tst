// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E.
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16907-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16907
//
// <-- Short Description -->
// Segmentation fault on false sparse matrix logical OR
//

assert_checkequal(sparse(%f) | %f, sparse(%f));
assert_checkequal(sparse(%f) | %t, sparse(%t));
assert_checkequal(sparse(%f) || %f, %f);
assert_checkequal(sparse(%f) || %t, %t);

assert_checkequal([%f, %f] | sparse(%f), sparse([%f, %f]));
assert_checkequal([%t, %t] | sparse(%f), sparse([%t, %t]));
assert_checkequal([%f, %f] || sparse(%f), %f);
assert_checkequal([%t, %t] || sparse(%f), %t);
