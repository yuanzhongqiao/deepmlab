// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15252 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15252
//
// <-- Short Description -->
// getURL does not work with accented words

expected = struct("name","Joël","gender","male","probability",1,"count",4);
computed = http_post("https://jsonplaceholder.typicode.com/posts", expected);
assert_checkequal(computed.name, expected.name);
