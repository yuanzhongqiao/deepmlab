// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 INRIA Serge.Steer@inria.fr
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 4715 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4715
//
// <-- Short Description -->
// CLR and DLR blocks ignore context set by scicos_simulate
//

importXcosDiagram(SCI+"/modules/xcos/tests/nonreg_tests/bug_4715.zcos");
global AA
AA=%nan

Info = scicos_simulate(scs_m,list(),struct(),"nw");
assert_checkalmostequal(AA, 7.2523740, 1E-4);

%scicos_context.a = 0.1;
%scicos_context.b = 0.1;

Info = scicos_simulate(scs_m,list(),%scicos_context,"nw");
assert_checkalmostequal(AA, 1.5601428, 1E-4);
