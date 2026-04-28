// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16333 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16333
//
// <-- Short Description -->
// tree_show(Xcos_diagram) and tree_show(Xcos_block) crash Scilab.

blk = BIGSOM_f("define");
tree_show(blk);

filename = SCI+"/modules/xcos/demos/demo_Datatype.xmi";
scs_m = scicosDiagramToScilab(filename);
tree_show(scs_m);

