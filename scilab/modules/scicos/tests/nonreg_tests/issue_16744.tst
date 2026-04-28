// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16744 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16744
// 
// <-- Non-regression test for bug 16106 -->
//
// <-- Short Description -->
// Inner I/O block's labels were not copied on sub-system copy.
// The port name was OK, the annotation label was not.
//

loadXcosLibs
scicos_log("INFO")

sb1 = SUPER_f('define');
sb1.model.label = "original";

// add a var name to subsystem ports
sb1.model.rpar.objs(1).model.label = "in1";
sb1.model.rpar.objs(2).model.label = "out1";
// add a label to the subsystem ports
sb1.model.rpar.objs(1).graphics.id = "label attached to the input";
sb1.model.rpar.objs(2).graphics.id = "label attached to the output";

// create a clone (the previous calls might move)
sb2 = sb1; // reference
sb2.model.label = "clone";

// Check the clone on model
assert_checkequal(sb2.model.rpar.objs(1).model.label, "in1")
assert_checkequal(sb2.model.rpar.objs(2).model.label, "out1")

// Check the clone on graphics
assert_checkequal(sb2.model.rpar.objs(1).graphics.id, "label attached to the input")
assert_checkequal(sb2.model.rpar.objs(2).graphics.id, "label attached to the output")
