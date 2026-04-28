// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17501 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17501
//
// <-- Short Description -->
// "strsplit" with array did not work on Scilab 2026.0.0

s1 = strsplit("aabcabbcbaaacacaabbcbccaaabcbc", ["aa" "bb"]);
s2 = strsplit("aabcabbcbaaacacaabbcbccaaabcbc", ["/aa|bb/"]);
assert_checkequal(s1, s2);
