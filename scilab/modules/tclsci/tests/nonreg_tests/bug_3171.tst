// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3171 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3171
//
// <-- Short Description -->
// TCL_EvalFile crash with slave interp

TCL_CreateSlave("myinterp");
tcl_script = [""];  // empty script
mputl(tcl_script,TMPDIR+"/bug_3171.tcl");
TCL_EvalFile(TMPDIR+"/bug_3171.tcl","myinterp");
