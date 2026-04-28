// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 17381 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17381
//
// <-- Short Description -->
// lambda is not manage in macr2tree, tree2code, and sci2exp.

f = #(x) -> (x+1);

tr = macr2tree(f);
assert_checkequal(tr.name, "anonymous");
assert_checkequal(tr.outputs, list());
assert_checkequal(tr.nblines, 1);

c = tree2code(tr);
assert_checkequal(c, ["#(x)->("; "x+1"; ")"; ""]);

str = sci2exp(f, "foo");
assert_checkequal(str, ["foo=#(x)->("; "x+1"; ")"; ""]);
execstr(str);
assert_checkequal(f, foo);


function test()
    #(x) -> (x+1)
end

tr = macr2tree(test);
assert_checkequal(typeof(tr.statements(2)), "lambda");
assert_checkequal(tr.statements(2).prototype, "#(x)->");
assert_checkequal(tr.statements(2).definition, "x + 1");

str = tree2code(tr);
assert_checkequal(str(2), "#(x)->(x + 1)");
