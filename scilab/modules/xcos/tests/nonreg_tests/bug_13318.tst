// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Vladislav TRUBKIN
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 13318 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13318
//
// <-- Short Description -->
// Output of CONST block is a vector and not a matrix.
//
global outmsg;
global toggle;
outmsg = [];
toggle = %T;

assert_checktrue(importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_13318.zcos"));
xcos_simulate(scs_m, 4);

refResult = [ones(100,1)*2 ones(100,1)*6 ones(100,1)*12];
assert_checkequal(refResult, result1.values);
assert_checkequal(refResult, result2.values);
refResult = [ones(100,1)*6 ones(100,1)*-6 zeros(100,1)];
assert_checkequal(refResult, result3.values);

// test with wrong values for CONST
prot = funcprot();
funcprot(0);
function str = x_mdialog(desc, labels, ini)
    global toggle;
    if toggle then
        str = ini;
        toggle = ~toggle;
    else
        str = []; // cancel button click to avoid an infinite loop in CONST.sci
    end
endfunction
function message(inmsg)
    global outmsg;
    outmsg = inmsg;
endfunction
funcprot(prot);

block = CONST("define");
block.graphics.exprs = ["[1 1; 1 1]"];
block = CONST("set", block);
assert_checkequal(outmsg, "The input value must be scalar.<br>Please use CONST_m to set a<br>constant input vector or matrix.");

block = CONST("define");
block.graphics.exprs = ["[1 1 1; -1 -2 -3; 0 0 0]"];
block = CONST("set", block);
assert_checkequal(outmsg, "The input value must be scalar.<br>Please use CONST_m to set a<br>constant input vector or matrix.");
