// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// Test an action performed on the CPGE toolbox but can be performed using only 
// Scilab code:
//   * get the objs list
//   * do some edit
//   * set it back to the original scs_m
//

loadXcosLibs;

// diagram definition, use "automatic" link-port resolution for simplicity

scicos_log("TRACE")

cst = GENSIN_f("define");

sb1 = SUPER_f("define");
sb1.model.rpar = scicos_diagram(objs = list(IN_f("define"), CSCOPE("define"), SampleCLK("define"), scicos_link(from=[1 1 0],to=[2 1 1]), scicos_link(from=[3 1 0],to=[2 1 1],ct=[1 -1])));

sb2 = SUPER_f("define");
sb2.model.rpar = scicos_diagram(objs = list(IN_f("define"), CSCOPE("define"), SampleCLK("define"), scicos_link(from=[1 1 0],to=[2 1 1]), scicos_link(from=[3 1 0],to=[2 1 1],ct=[1 -1])));

split = SPLIT_f("define");

scs_m = scicos_diagram(objs = list(cst, sb1, sb2, split, scicos_link(from=[1 1 0],to=[4 1 1]), scicos_link(from=[4 1 0],to=[2 1 1]), scicos_link(from=[4 2 0],to=[3 1 1])));
clear cst sb1 sb2 split

// test a list assignement and back
scs_m_good = scs_m;
disp(scs_m.objs(5))
disp(scs_m.objs(6))
disp(scs_m.objs(7))

i=2
obj2 = scs_m.objs(i);
if typeof(obj2) <> "Block" then pause, end
if obj2.gui <> "SUPER_f" then pause, end

list_obj2_before = scs_m.objs(i).model.rpar.objs;
scs_m.objs(i).model.rpar.objs = list_obj2_before;
list_obj2_after = scs_m.objs(i).model.rpar.objs;

scs_m_after_obj2 = scs_m
disp(scs_m.objs(5))
disp(scs_m.objs(6))
disp(scs_m.objs(7))

disp(scs_m_after_obj2.objs(5))
disp(scs_m_after_obj2.objs(6))
disp(scs_m_after_obj2.objs(7))

assert_checktrue(and(list_obj2_before == list_obj2_after))
assert_checktrue(and(scs_m_after_obj2 == scs_m))
assert_checktrue(and(scs_m_after_obj2 == scs_m_good))


// this clear is not supposed to interact with neither scs_m or other variable content, it was !
clear list_obj2_before list_obj2_after scs_m_after_obj2

i=3
obj3 = scs_m.objs(i);
if typeof(obj3) <> "Block" then pause, end
if obj3.gui <> "SUPER_f" then pause, end

list_obj3_before = scs_m.objs(i).model.rpar.objs;
scs_m.objs(i).model.rpar.objs = list_obj3_before;
list_obj3_after = scs_m.objs(i).model.rpar.objs;

scs_m_after_obj3 = scs_m
disp(scs_m.objs(5))
disp(scs_m.objs(6))
disp(scs_m.objs(7))

disp(scs_m_after_obj3.objs(5))
disp(scs_m_after_obj3.objs(6))
disp(scs_m_after_obj3.objs(7))

assert_checktrue(and(list_obj3_before == list_obj3_after))
assert_checktrue(and(scs_m_after_obj3 == scs_m))
assert_checktrue(and(scs_m_after_obj3 == scs_m_good))
