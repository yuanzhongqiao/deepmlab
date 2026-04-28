// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clement DAVID
//
// This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- XCOS TEST -->
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 15024 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15024
//
// <-- Short Description -->
// the labels were not preserved when reloading a block
//

loadXcosLibs();
scicos_log("TRACE");

function scs_m = load_cosf(f)
    exec(f);
endfunction

scs_m1 = load_cosf(SCI + "/modules/xcos/tests/nonreg_tests/bug_15024.cosf");
scs_m = scs_m1;

// link labels
assert_checkequal(scs_m.objs(4).id, "link1");
assert_checkequal(scs_m.objs(5).id, "link2");

// labels inside the superblock
assert_checkequal(scs_m.objs(3).model.rpar.objs(1).graphics.id, "bigsom annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(1).model.label, "bigsom")
assert_checkequal(scs_m.objs(3).model.rpar.objs(2).graphics.id, "input1 annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(2).model.label, "input1")
assert_checkequal(scs_m.objs(3).model.rpar.objs(3).graphics.id, "input2 annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(3).model.label, "input2")

// save a copy and recheck
cos2cosf(TMPDIR + "/bug_15024.cosf", scs_m);
scs_m2 = load_cosf(TMPDIR + "/bug_15024.cosf");
scs_m = scs_m2;

// link labels
assert_checkequal(scs_m.objs(4).id, "link1");
assert_checkequal(scs_m.objs(5).id, "link2");

// labels inside the superblock
assert_checkequal(scs_m.objs(3).model.rpar.objs(1).graphics.id, "bigsom annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(1).model.label, "bigsom")
assert_checkequal(scs_m.objs(3).model.rpar.objs(2).graphics.id, "input1 annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(2).model.label, "input1")
assert_checkequal(scs_m.objs(3).model.rpar.objs(3).graphics.id, "input2 annotation")
assert_checkequal(scs_m.objs(3).model.rpar.objs(3).model.label, "input2")
