// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17435 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17435
//
// <-- Short Description -->
// struct2table did not support empty matrices

s=struct("a",1,"b",[]);
s(2)=s;
t = struct2table(s);

assert_checkequal(t.a, [1; 1]);
assert_checkequal(t.b, {[]; []});
assert_checkequal(size(t), [2 2]);
assert_checkequal(t.Properties.VariableNames, ["a", "b"]);
