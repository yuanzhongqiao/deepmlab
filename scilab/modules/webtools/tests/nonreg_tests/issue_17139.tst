// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17139 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17139
//
// <-- Short Description -->
// fromJSON creates SingleStruct with nullptr in data that make scilab crash.

expected = struct("root", []);

expected.root= list(list(struct("a", %t), struct("b", 4)));
computed = fromJSON("{""root"": [[{""a"": true}, {""b"":4}]]}")
assert_checkequal(computed, expected);

expected.root = struct("a", %t);
expected.root(1,2).a = 4;
computed = fromJSON("{""root"": [[{""a"": true}, {""a"":4}]]}")
assert_checkequal(computed, expected);

expected.root = struct("a", %f);
expected.root(1,2).a = 40;
expected.root(2,1).a = %t;
expected.root(2,2).a = 4;
computed = fromJSON("{""root"": [[{""a"": false}, {""a"":40}],[{""a"": true}, {""a"":4}]]}");
assert_checkequal(computed, expected);

expected.root = list(list(struct("a", %f)));
expected.root(1)(2) = struct("b", 40);
expected.root(2) = list(struct("a", %t));
expected.root(2)(2) = struct("b", 4);
computed = fromJSON("{""root"": [[{""a"": false}, {""b"":40}],[{""a"": true}, {""b"":4}]]}")
assert_checkequal(computed, expected);

expected.root = list(struct("a", %f));
expected.root(1)(1,2).a = 40;
expected.root(2) = list(struct("a", %t));
expected.root(2)(2) = struct("b", 4);
computed = fromJSON("{""root"": [[{""a"": false}, {""a"":40}],[{""a"": true}, {""b"":4}]]}")
assert_checkequal(computed, expected);