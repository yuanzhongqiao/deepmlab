// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Pierre-Aimé AGNEL
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 14681 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14681
//
// <-- Short Description -->
//    Short circuited AND operation was not possible with double matrices in if and while clauses

// Testing if
global("bar");
bar = 0;
function res = foo()
    warning("foo() should not be executed in this test");
    global("bar");
    bar = 1;
    res = %t;
endfunction

andCond = %f;
orCond = %t;

if andCond && foo() then; end
assert_checkequal(bar, 0);
if andCond & foo() then; end
assert_checkequal(bar, 0);
if orCond | foo() then; end
assert_checkequal(bar, 0);
if orCond || foo() then; end
assert_checkequal(bar, 0);

andCond = 0;
orCond = 1;
if andCond && foo() then; end
assert_checkequal(bar, 0);
if andCond & foo() then; end
assert_checkequal(bar, 0);
if orCond | foo() then; end
assert_checkequal(bar, 0);
if orCond || foo() then; end
assert_checkequal(bar, 0);

andCond = int8(0);
orCond = int8(1);
if andCond && foo() then; end
assert_checkequal(bar, 0);
if andCond & foo() then; end
assert_checkequal(bar, 0);
if orCond | foo() then; end
assert_checkequal(bar, 0);
if orCond || foo() then; end
assert_checkequal(bar, 0);

clearglobal("bar");
